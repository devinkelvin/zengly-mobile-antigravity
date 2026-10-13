import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.zengly.dev"
            resValue(type = "string", name = "app_name", value = "Zengly Dev")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.zengly.prod"
            resValue(type = "string", name = "app_name", value = "Zengly")
        }
    }
}