allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory for root project
buildDir = file("../../build")

subprojects {
    // Set custom build directory for subprojects
    buildDir = file("../../build/${project.name}")
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(buildDir)
}
