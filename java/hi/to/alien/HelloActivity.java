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

    if (!initialized) {
      initialized = true;
      setupLisp("libcore.so");
    }

    TextView text = new TextView(this);
    text.setText(getAlien());

    setContentView(text);
  }

  public void setupLisp(String coreName) {
    String corePath = getApplicationInfo().nativeLibraryDir;
    String coreFullName = corePath + "/" + coreName;

    File core = new File(corePath, coreName);

    if (core.exists()) {
      Log.v("ALIEN", "Core file is at " +  coreFullName);
      initLisp(coreFullName);
      Log.v("ALIEN", "Lisp initialised by core " + coreFullName);
    } else {
      Log.v("ALIEN", "Core is lost! 0.0");
    }
  }

  public native void initLisp(String path);
  public native String getAlien();
  private static boolean initialized = false;

  static {
    System.loadLibrary("sbcl");
    System.loadLibrary("hello-alien");
  }
}
