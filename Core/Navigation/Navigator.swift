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

public class Navigator {
    private var providers: [String: AnyObject] = [:]

    public static let instance = Navigator()

    func registerProvider(_ providerKey: Any, _ provider: AnyObject?) {
        let key = String(describing: providerKey.self)
        self.providers[key] = provider
    }

    public func getProvider<T>(_ module: Any) -> T {
        let key = String(describing: module.self)
        guard let provider = self.providers[key] as? T else {
            preconditionFailure("Provider \(key) is not registered")
        }
        return provider
    }
}
