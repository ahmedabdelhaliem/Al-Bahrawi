allprojects {
    repositories {
        google()
        mavenCentral()
    }

//    subprojects {
//        project.configurations.all {
//            resolutionStrategy.eachDependency { details ->
//                if (details.requested.group == 'com.android.support'
//                    && !details.requested.name.contains('multidex') ) {
//                    details.useVersion "27.1.1"
//                }
//            }
//        }
//    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
