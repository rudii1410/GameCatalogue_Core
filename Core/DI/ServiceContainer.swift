//
//  This file is part of Game Catalogue.
//
//  Game Catalogue is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Game Catalogue is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Game Catalogue.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI

public typealias ServiceCreator = (ServiceContainer) -> AnyObject

public class ServiceContainer {
    private var container: [String: AnyObject] = [:]
    private var services: [String: ServiceCreator] = [:]

    public static var instance = ServiceContainer()
    public init() {}

    public func register(_ service: Any, _ callback: @escaping ServiceCreator) {
        let key = String(describing: service.self)
        if self.services[key] == nil {
            self.services[key] = callback
            print("\(key) is registered")
        }
    }

    public func unregister(_ service: AnyClass) {
        let key = String(describing: service.self)
        self.services.removeValue(forKey: key)
    }

    public func get<T>() -> T {
        let key = String(describing: T.self)

        guard let service = self.container[key] as? T else {
            print("\(key) object is not created, creating new object.")
            return self.resolveService(key: key)
        }
        return service
    }

    public func remove(_ service: AnyClass) {
        let key = String(describing: service.self)
        self.container.removeValue(forKey: key)
    }

    private func resolveService<T>(key: String) -> T {
        guard let serviceObject = self.services[key]?(self) as? T else {
            preconditionFailure("\(key) is not registered in service container")
        }
        self.container[key] = serviceObject as AnyObject
        return serviceObject
    }
}
