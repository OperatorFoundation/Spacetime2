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
        guard let r = universe.random() else
        {
            XCTFail()
            return
        }
        universe.display(r.string)
    }

    func testUniverseSubclass() throws
    {
        let done = expectation(description: "awaited universe.run()")

        let simulation = Simulation(capabilities: Capabilities(display: true, random: true))
        let universe = TestUniverse(effects: simulation.effects, events: simulation.events)

        Task
        {
            try universe.run()
            done.fulfill()
        }

        wait(for: [done], timeout: 10)
    }

    func testUniverseSubclassNetworkClient() throws
    {
        let done = expectation(description: "awaited universe.run()")

        let simulation = Simulation(capabilities: Capabilities(display: true, networkConnect: true, random: true))
        let universe = TestNetworkClientUniverse(effects: simulation.effects, events: simulation.events)

        Task
        {
            try universe.run()
            done.fulfill()
        }

        wait(for: [done], timeout: 10)
    }

    func testUniverseSubclassNetworkServer() throws
    {
        let done = expectation(description: "awaited universe.run()")

        let simulation = Simulation(capabilities: Capabilities(display: true, networkListen: true, random: true))
        let universe = TestNetworkServerUniverse(effects: simulation.effects, events: simulation.events)

        Task
        {
            try universe.run()
            done.fulfill()
        }

        wait(for: [done], timeout: 10)
    }

    class TestUniverse: Universe
    {
        public override func main() throws
        {
            display("Hello universe!")
            guard let r = self.random() else
            {
                XCTFail()
                return
            }
            display(r.string)
            display("done")
        }
    }

    class TestNetworkClientUniverse: Universe
    {
        public override func main() throws
        {
            let connection = try connect("127.0.0.1", 1234)
            guard let r = self.random() else
            {
                XCTFail()
                return
            }
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
            guard let connection = listener.accept() else
            {
                XCTFail()
                return
            }

            guard let r = self.random() else
            {
                XCTFail()
                return
            }
            let _ = connection.write(data: r.data)
            guard let result = connection.read(size: 4) else {return}
            display(result.string)
            display("done")
        }
    }
}
