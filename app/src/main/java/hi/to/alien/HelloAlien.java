package hi.to.alien;

import android.app.Activity;
import android.widget.TextView;
import android.os.Bundle;
import android.util.Log;

public class HelloAlien extends Activity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    TextView text = new TextView(this);
    Log.v("ALIEN", "Created text view :D ");
    text.setText(getAlien());
    setContentView(text);
  }
  public static void setupCore() {
    // String libsPath = mContext.getApplicationInfo().nativeLibraryDir;
    String libsPath = "/data/data/hi.to.alien/lib/";
    String coreName = libsPath + "libcore.so";
    setCorePath(coreName);
    Log.v("ALIEN", "core path is set to " + coreName + " :) ");
  }
  public native String getAlien();
  public static native void setCorePath(String name);
  static {
    System.loadLibrary("sbcl");
    Log.v("ALIEN", "sbcl loaded");
    System.loadLibrary("hello-alien");
    Log.v("ALIEN", "hello-alien loaded");
    setupCore();
  }
}
