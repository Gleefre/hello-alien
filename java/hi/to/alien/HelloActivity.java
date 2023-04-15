package hi.to.alien;

import android.app.Activity;
import android.widget.TextView;
import android.os.Bundle;
import android.util.Log;

import java.io.File;

public class HelloActivity extends Activity {
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    setupCore("libcore.so");

    TextView text = new TextView(this);
    text.setText(getAlien());

    setContentView(text);
  }

  public void setupCore(String coreName) {
    String corePath = getApplicationInfo().nativeLibraryDir;
    String coreFullName = corePath + "/" + coreName;

    File core = new File(corePath, coreName);

    if (core.exists()) {
      Log.v("ALIEN", "Core file is at " +  coreFullName);
      setCorePath(coreFullName);
      Log.v("ALIEN", "Path to core is set to " + coreFullName);
    } else {
      Log.v("ALIEN", "Core is lost! 0.0");
    }
  }

  public native String getAlien();
  public static native void setCorePath(String name);

  static {
    System.loadLibrary("sbcl");
    System.loadLibrary("hello-alien");
  }
}
