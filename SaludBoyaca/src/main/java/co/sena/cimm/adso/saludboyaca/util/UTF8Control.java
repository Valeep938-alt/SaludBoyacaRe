package co.sena.cimm.adso.saludboyaca.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.Locale;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;

public class UTF8Control extends ResourceBundle.Control {

    @Override
    public ResourceBundle newBundle(String baseName, Locale locale,
            String format, ClassLoader loader, boolean reload)
            throws IllegalAccessException, InstantiationException, IOException {

        String bundleName = toBundleName(baseName, locale);
        String resourceName = toResourceName(bundleName, "properties");

        InputStream stream = null;

        if (reload) {
            URL url = loader.getResource(resourceName);
            if (url != null) {
                URLConnection conn = url.openConnection();
                conn.setUseCaches(false);
                stream = conn.getInputStream();
            }
        } else {
            stream = loader.getResourceAsStream(resourceName);
        }

        if (stream == null) return null;

        try (InputStreamReader reader = new InputStreamReader(stream, "UTF-8")) {
            return new PropertyResourceBundle(reader);
        }
    }
}