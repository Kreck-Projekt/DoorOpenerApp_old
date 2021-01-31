package com.example.DoorOpener

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.FlutterFragmentActivity


class MyActivity : FragmentActivity() {
    companion object {
        // Define a tag String to represent the FlutterFragment within this
        // Activity's FragmentManager. This value can be whatever you'd like.
        private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
    }

    // Declare a local variable to reference the FlutterFragment so that you
    // can forward calls to it later.
    private var flutterFragment: FlutterFragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Inflate a layout that has a container for your FlutterFragment. For
        // this example, assume that a FrameLayout exists with an ID of
        // R.id.fragment_container.
        setContentView(R.layout.my_activity_layout)

        // Get a reference to the Activity's FragmentManager to add a new
        // FlutterFragment, or find an existing one.
        val fragmentManager: FragmentManager = supportFragmentManager

        // Attempt to find an existing FlutterFragment, in case this is not the
        // first time that onCreate() was run.
        flutterFragment = fragmentManager
                .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

        // Create and attach a FlutterFragment if one does not exist.
        if (flutterFragment == null) {
            var newFlutterFragment = FlutterFragment.createDefault()
            flutterFragment = newFlutterFragment
            fragmentManager
                    .beginTransaction()
                    .add(
                            R.id.fragment_container,
                            newFlutterFragment,
                            TAG_FLUTTER_FRAGMENT
                    )
                    .commit()
        }
    }
}
