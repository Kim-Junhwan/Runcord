//
//  DependencyInjector.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/27.
//

import Swinject

protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T)
}

protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
    func resolve<T, Arg1>(_ serviceType: T.Type, argument: Arg1) -> T
    func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, argument: Arg1, arg2: Arg2) -> T
}

typealias Injector = DependencyAssemblable & DependencyResolvable

final class DependencyInjector {
    
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
}

extension DependencyInjector: Injector {
    
    
    func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach { $0.assemble(container: container) }
    }
    
    func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in
            return object
        }
    }
    
    func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
    
    func resolve<T, Arg1>(_ serviceType: T.Type, argument: Arg1) -> T {
        container.resolve(serviceType, argument: argument)!
    }
    
    func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, argument: Arg1, arg2: Arg2) -> T {
        container.resolve(serviceType, arguments: argument, arg2)!
    }
}
