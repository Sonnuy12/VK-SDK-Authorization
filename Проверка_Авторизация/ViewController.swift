//
//  ViewController.swift
//  Проверка_Авторизация
//
//  Created by сонный on 16.12.2024.
//
import UIKit
import VKID
import VKIDCore

class ViewController: UIViewController {
    var vkid: VKID! // Убедитесь, что vkid передается при инициализации

    override func viewDidLoad() {
        super.viewDidLoad()
        createBackround()
        //view.backgroundColor = .white
        
        setupVKIDButton()
    }

    private func setupVKIDButton() {
        // Создаем кнопку "One Tap"
        let oneTap = OneTapButton(
            appearance: .init(
                title: .open,
                style: .primary(logo: .vkidPrimary),
                theme: .matchingColorScheme(.light)
            ),
            layout: .regular(
                height: .large(.h56),
                cornerRadius: 28
            ),
            presenter: .newUIWindow // Отображение кнопки как модального окна
        ) { [weak self] authResult in
            self?.handleAuthResult(authResult)
        }

        // Создаем UI элемент кнопки
        let oneTapView = vkid.ui(for: oneTap).uiView()
        oneTapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем на экран
        view.addSubview(oneTapView)
        
        // Настраиваем автолейаут
        NSLayoutConstraint.activate([
            oneTapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oneTapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            oneTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            oneTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            oneTapView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func handleAuthResult(_ authResult: Result<UserSession, AuthError>) {
        // Обработка результата авторизации
        switch authResult {
        case .success(let session):
            print("Авторизация успешна! Token: \(session.accessToken), User ID: \(String(describing: session.user))")
        case .failure(AuthError.cancelled):
            print("Авторизация отменена пользователем")
        case .failure(let error):
            print("Ошибка авторизации: \(error.localizedDescription)")
        }
    }
    
    func createBackround() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "BackroundAuthorization")
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
    }
}
