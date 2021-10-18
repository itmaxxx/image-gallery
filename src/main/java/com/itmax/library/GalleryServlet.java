package com.itmax.library;

import com.itmax.library.models.Picture;
import com.itmax.library.util.Db;
import com.itmax.library.util.Hasher;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;

public class GalleryServlet extends HttpServlet {

    @Override
    @SuppressWarnings("unchecked")
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pictureId = req.getParameter("id");
        JSONObject answer = new JSONObject();

        if (pictureId == null || "".equals(pictureId)) {
            answer.put("status", "-1");
            answer.put("message", "picture id required");
        } else {
            if (Db.deletePictureById(pictureId)) {
                answer.put("success", "true");
                answer.put("message", "picture with id " + pictureId + " was deleted");
            } else {
                answer.put("error", "true");
                answer.put("message", "failed to delete picture");
            }
        }

        resp.setContentType("application/json");
        resp.getWriter().print(answer);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        String[] sessionAttributes = {"uploadMessage", "galleryDescription"};
        for (String attrName : sessionAttributes) {
            String attrValue = (String)
                    session.getAttribute(attrName);
            if (attrValue != null) {
                session.removeAttribute(attrName);
            } else {
                attrValue = "";
            }
            req.setAttribute(attrName, attrValue);
        }

        ArrayList<Picture> pictures = Db.getPictures();

        Picture[] picturesArr = (pictures == null)
                ? new Picture[0]
                : pictures.toArray(new Picture[0]);

        // Pass pictures array to view
        req.setAttribute("pictures", picturesArr);

        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        Part filePart = req.getPart("galleryFile");

        String uploadMessage = "";
        String description = req.getParameter("galleryDescription");
        String attachedFilename = null;
        String contentDisposition = filePart.getHeader("content-disposition");

        if (contentDisposition != null) {
            for (String part : contentDisposition.split("; ")) {
                if (part.startsWith("filename")) {
                    attachedFilename = part.substring(10, part.length() - 1);
                    break;
                }
            }
        }
        if (attachedFilename != null) {
            String extension;

            int dotPosition = attachedFilename.lastIndexOf(".");

            if (dotPosition > -1) {
                extension = attachedFilename.substring(dotPosition);

                String[] allowedExtensions = new String[] {".jpg", ".jpeg", ".png"};

                System.out.println(extension);

                if(!Arrays.asList(allowedExtensions).contains(extension)) {
                    session.setAttribute("uploadMessage", "This file extension not allowed");

                    resp.sendRedirect(req.getRequestURI());
                    return;
                }

                String path = req.getServletContext().getRealPath("/uploads");
                File destination;
                String filename, savedFilename;

                // If file with this name exists regenerate
                do {
                    // Generate random file name and set extension
                    savedFilename = Hasher.hash(attachedFilename) + extension;

                    // Full path
                    filename = path + "\\" + savedFilename;
                    destination = new File(filename);
                    attachedFilename = savedFilename;
                } while (destination.exists());

                Files.copy(
                        filePart.getInputStream(),
                        destination.toPath(),
                        StandardCopyOption.REPLACE_EXISTING
                );

                path = "C:\\Users\\dmitr\\IdeaProjects\\library\\src\\main\\webapp\\uploads";
                filename = path + "\\" + savedFilename;
                destination = new File(filename);

                Files.copy(
                        filePart.getInputStream(),
                        destination.toPath(),
                        StandardCopyOption.REPLACE_EXISTING
                );

                // Add file path to db
                if (Db.addPicture(new Picture(savedFilename, description))) {
                    uploadMessage = "Image successfully uploaded";
                } else {
                    uploadMessage = "Failed to upload image";
                }
            } else {
                attachedFilename = "no file extension";
            }
        }

        session.setAttribute("uploadMessage", uploadMessage);
        session.setAttribute("galleryDescription", description);

        resp.sendRedirect(req.getRequestURI());
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        try {
            InputStream reader = req.getInputStream();
            StringBuilder sb = new StringBuilder();

            int sym;

            while ((sym = reader.read()) != -1) {
                sb.append((char) sym);
            }

            String body = new String(
                    sb.toString().getBytes(
                            StandardCharsets.ISO_8859_1),
                    StandardCharsets.UTF_8
            );

            if (body.contains("?")) {
                resp.getWriter().print("{\"status\":-3}");

                return;
            }

            JSONObject params = (JSONObject) new JSONParser().parse(body);

            if (Db.updatePicture(new Picture((String) params.get("id"), null, (String) params.get("description"),null))) {
                resp.getWriter().print("{\"status\":1}");
            } else {
                resp.getWriter().print("{\"status\":-1}");
            }
        } catch (Exception ex) {
            System.err.println("GalleryServlet(PUT): " + ex.getMessage());

            resp.getWriter().print("{\"status\":-2}");
        }
    }
}