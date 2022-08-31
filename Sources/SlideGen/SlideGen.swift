import ArgumentParser
import Foundation
import Logging
import Stencil
import PathKit
import ProjectSpec
import XcodeGenKit

let logger = Logger(label: "net.matsuji.slidegen")

@main
struct SlideGen: ParsableCommand {
    @Argument var productName: String

    @Option(name: .shortAndLong, help: "A project platform")
    var platform: SupportedPlatform = .iOS

    mutating func run() throws {
        guard !FileManager.default.fileExists(atPath: productName) else {
            logger.error("\(productName) exist.")
            return
        }
        try FileManager.default.createDirectory(atPath: productName + "/" + productName + "/Slides", withIntermediateDirectories: true)

        switch platform {
        case .iOS:
            try copySwiftFile(templateName: "AppDelegate.swift")
            try copySwiftFile(templateName: "SceneDelegate.swift")
            try copySwiftFile(templateName: "SampleSlide.swift", fileName: "Slides/SampleSlide.swift")
            try copyFile(templateName: "Info.plist")
            try copyFile(templateName: "project.yml", filePath: URL(fileURLWithPath: "./\(productName)/project.yml"))
        case .macOS:
            try copySwiftFile(templateName: "App.swift", fileName: productName + "_App.swift")
            try copySwiftFile(templateName: "SampleSlide.swift", fileName: "Slides/SampleSlide.swift")
            try copyFile(templateName: "Info.plist")
            try copyFile(
                templateName: "ProductName.entitlements",
                filePath: URL(fileURLWithPath: "./\(productName)/\(productName)/\(productName).entitlements")
            )
            try copyFile(templateName: "project.yml", filePath: URL(fileURLWithPath: "./\(productName)/project.yml"))
        }
        try makeXcodeProject()
        logger.info("Creating \(productName) has been succeeded.")
    }

    private func copySwiftFile(templateName: String, fileName: String? = nil) throws {
        try copyFile(
            templateName: templateName,
            filePath: URL(fileURLWithPath: "./\(productName)/\(productName)/" + (fileName ?? templateName))
        )
    }

    private func copyFile(templateName: String, filePath: URL? = nil) throws {
        let fileSystemLoader = FileSystemLoader(bundle: [Bundle.main, Bundle.module])
        let environment = Environment(loader: fileSystemLoader)

        let context = [
            "productName": productName,
            "slideKitVersion": slideKitVersion.description
        ]
        let content = try environment.renderTemplate(name: platform.rawValue + "_" + templateName + ".stencil", context: context)
        let url = filePath ?? URL(fileURLWithPath: "./\(productName)/\(productName)/\(templateName)")
        logger.debug("Writing to \(url.absoluteString)")
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    private func makeXcodeProject() throws {
        let specLoader = SpecLoader(version: xcodeGenVersion)
        let project = try specLoader.loadProject(path: Path("./\(productName)/project.yml"))
        try specLoader.validateProjectDictionaryWarnings()

        let projectPath = "./\(project.name)/\(productName).xcodeproj"
        try project.validateMinimumXcodeGenVersion(xcodeGenVersion)
        try project.validate()
        let fileWriter = FileWriter(project: project)
        try fileWriter.writePlists()
        let projectGenerator = ProjectGenerator(project: project)
        let xcodeProject = try projectGenerator.generateXcodeProject(in: Path("./\(project.name)/"))
        try fileWriter.writeXcodeProject(xcodeProject, to: Path(projectPath))
    }
}

enum SupportedPlatform: String, Codable, ExpressibleByArgument {
    case macOS
    case iOS
}
