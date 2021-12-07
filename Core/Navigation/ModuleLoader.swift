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

public typealias ModuleCreator = (ModuleLoader) -> AnyObject

public class ModuleLoader {
    private var modules: [String: Module] = [:]

    public init() {}

    public func registerModule(module: Any, provider: Any, _ callback: @escaping ModuleCreator) {
        let key = String(describing: module.self)
        let module = callback(self)

        self.modules[key] = module as? Module
        Navigator.instance.registerProvider(provider, module)
    }

    public func loadAllModules() {
        for (key, value) in self.modules {
            print("Loading module \(key)")
            value.load()
        }
    }
}
