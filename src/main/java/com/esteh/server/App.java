package com.esteh.server;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class App {
    public static void main(String[] args) throws Exception {
        int port = 8080;
        String portEnv = System.getenv("PORT");
        if (portEnv != null && !portEnv.trim().isEmpty()) {
            try {
                port = Integer.parseInt(portEnv.trim());
            } catch (NumberFormatException ignore) {}
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        File baseDir = new File("target/tomcat");
        if (!baseDir.exists()) {
            baseDir.mkdirs();
        }
        tomcat.setBaseDir(baseDir.getAbsolutePath());
        tomcat.getConnector();

        String webappDirLocation = new File("src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDirLocation);
        ctx.setParentClassLoader(App.class.getClassLoader());
        ctx.setDelegate(true);

        File additionWebInfClasses = new File("target/classes");
        WebResourceRoot resources = new StandardRoot(ctx);
        if (additionWebInfClasses.exists()) {
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
        }
        ctx.setResources(resources);

        System.out.println("=========================================================");
        System.out.println("  ES TEH SOLO - Sistem Pemesanan Minuman Online");
        System.out.println("  Server berjalan di: http://localhost:" + port);
        System.out.println("  Akun Admin: admin@estehsolo.com / password: admin123");
        System.out.println("  Akun User : budi@gmail.com / password: user123");
        System.out.println("=========================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
