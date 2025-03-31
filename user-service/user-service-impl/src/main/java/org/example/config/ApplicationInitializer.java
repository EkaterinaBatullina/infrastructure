package org.example.config;

import jakarta.servlet.Servlet;
import jakarta.servlet.ServletRegistration;
import lombok.SneakyThrows;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;

public class ApplicationInitializer implements WebApplicationInitializer {

    @SneakyThrows
    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        AnnotationConfigWebApplicationContext springWebContext = new AnnotationConfigWebApplicationContext();
        springWebContext.register(WebMvcConfig.class);
        springWebContext.register(DataBaseConfig.class);
        servletContext.addListener(new ContextLoaderListener(springWebContext));
        ServletRegistration.Dynamic dispatcherServlet =
                (ServletRegistration.Dynamic) servletContext.addServlet("dispatcher", new DispatcherServlet(springWebContext));
        dispatcherServlet.setLoadOnStartup(1);
        dispatcherServlet.addMapping("/");
    }
}