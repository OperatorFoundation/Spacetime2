import XCTest
@testable import Simulation
@testable import Universe
import Spacetime
import Datable

final class SpacetimeTests: XCTestCase {
    func testUniverse() throws
    {
        let simulation = Simulation(capabilities: Capabilities(display: true))
        let universe = Universe(effects: simulation.effects, events: simulation.events)
        universe.display("test1")
    }

    func testRandom() throws
    {
        let simulation = Simulation(capabilities: Capabilities(display: true, random: true))
        let universe = Universe(effects: simulation.effects, events: simulation.events)
        let r = universe.random()
        universe.display(r.string)
    }

    func testUniverseSubclass() throws
    {
        let simulation = Simulation(capabilities: Capabilities(display: true, random: true))
        let universe = TestUniverse(effects: simulation.effects, events: simulation.events)
        try universe.run()
    }

    func testUniverseSubclassNetworkClient() throws
    {
        let simulation = Simulation(capabilities: Capabilities(display: true, networkConnect: true, random: true))
        let universe = TestNetworkClientUniverse(effects: simulation.effects, events: simulation.events)
        try universe.run()
    }

    func testUniverseSubclassNetworkServer() throws
    {
        let simulation = Simulation(capabilities: Capabilities(display: true, networkListen: true, random: true))
        let universe = TestNetworkServerUniverse(effects: simulation.effects, events: simulation.events)
        try universe.run()
    }

    class TestUniverse: Universe
    {
        public override func main() throws
        {
            display("Hello universe!")
            let r = random()
            display(r.string)
            display("done")
        }
    }

    class TestNetworkClientUniverse: Universe
    {
        public override func main() throws
        {
            let connection = try connect("127.0.0.1", 1234)
            let r = random()
            let _ = connection.write(data: r.data)
            guard let result = connection.read(size: 4) else {return}
            display(result.string)
            display("done")
        }
    }

    class TestNetworkServerUniverse: Universe
    {
        public override func main() throws
        {
            let listener = try listen("127.0.0.1", 1234)
            let connection = listener.accept()
            let r = random()
            let _ = connection.write(data: r.data)
            guard let result = connection.read(size: 4) else {return}
            display(result.string)
            display("done")
        }
    }
}
