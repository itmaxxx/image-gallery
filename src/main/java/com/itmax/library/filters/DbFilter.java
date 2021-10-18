package com.itmax.library.filters;

import com.itmax.library.util.Db;
import org.json.simple.parser.JSONParser;
import org.json.simple.JSONObject;

import javax.servlet.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;

public class DbFilter implements Filter {

    private FilterConfig filterConfig;
    private String configName = "db2.json";

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        servletRequest.setCharacterEncoding("UTF-8");
        servletResponse.setCharacterEncoding("UTF-8");

        Db.setConnection(null);
        File config = new File(filterConfig.getServletContext().getRealPath("/WEB-INF/config/") + "/" + configName);

        if (!config.exists()) {
            System.err.println("config/" + configName + " not found");
        } else {
            try (InputStream reader = new FileInputStream(config)) {
                int fileLength = (int) config.length();
                byte[] buf = new byte[fileLength];

                if (reader.read(buf) != fileLength)
                    throw new IOException("File read integrity falls");

                JSONObject configData = (JSONObject) new JSONParser().parse(new String(buf));

                if (!Db.setConnection(configData))
                    throw new SQLException("Db connection error");
            } catch (Exception ex) {
                System.err.println(ex.getMessage());
            }
        }
        // Checking connection to be opened
        if (Db.getConnection() == null) {
            // No connection - use static mode
            servletRequest
                    .getRequestDispatcher("/static.jsp")
                    .forward(servletRequest, servletResponse);
        } else {
            filterChain.doFilter(servletRequest, servletResponse);
            Db.closeConnection();
        }
    }

    @Override
    public void destroy() {
        filterConfig = null;
    }
}
