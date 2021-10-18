<%@ page import="com.itmax.library.models.Picture" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Gallery</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="css/gallery.css"/>
</head>
<body>

<header>
    <div class="navbar navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a href="#" class="navbar-brand d-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" stroke="currentColor"
                     stroke-linecap="round" stroke-linejoin="round" stroke-width="2" aria-hidden="true" class="me-2"
                     viewBox="0 0 24 24">
                    <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/>
                    <circle cx="12" cy="13" r="4"/>
                </svg>
                <strong>Gallery</strong>
            </a>
            <a href="form.jsp" class="navbar-toggler" type="button"
            >
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                     class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0v-2z"></path>
                    <path fill-rule="evenodd"
                          d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"></path>
                </svg>
            </a>
        </div>
    </div>
</header>

<main>

    <section class="py-5 text-center container">
        <div class="row py-lg-5">
            <div class="col-lg-6 col-md-8 mx-auto">
                <h1 class="fw-light">Upload Your Image</h1>

                <form method="post"
                      enctype="multipart/form-data"
                      action="">
                    <div class="mb-3">
                        <label for="formFile" class="form-label">Image to upload</label>
                        <input class="form-control" type="file" id="formFile" name="galleryFile" required>
                    </div>
                    <div class="mb-3">
                        <label for="descriptionFormControlTextarea" class="form-label">Image Description</label>
                        <textarea name="galleryDescription" class="form-control" id="descriptionFormControlTextarea"
                                  rows="3"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" value="Send">Upload</button>
                </form>

                <% String uploadMessage = (String)
                        request.getAttribute("uploadMessage");
                    if (uploadMessage != null) { %>

                <b><%= uploadMessage %>
                </b>

                <% } %>

            </div>
        </div>
    </section>

    <div class="album py-5 bg-light">
        <div class="container">

            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">

                <% Picture[] pictures;

                    try {
                        pictures = (Picture[])
                                request.getAttribute("pictures");
                    } catch (ClassCastException ignored) {
                        pictures = new Picture[0];
                    }
                    if (pictures != null)
                        for (Picture pic : pictures) { %>
                <div class="col picture">
                    <div class="card shadow-sm">
                        <img class="bd-placeholder-img card-img-top" width="100%" height="225"
                             src="uploads/<%= pic.getName() %>" alt="<%= pic.getName() %>"/>

                        <div class="card-body">

                            <%
                                String description = pic.getDescription();
                                if (description != null) { %>
                                    <p class="card-text"><%= description %></p>
                            <%  } %>

                            <tt class="d-none"><%= pic.getId() %></tt>
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="btn-group">
                                    <button type="button" class="btn btn-sm btn-outline-light tool-button tool-edit" title="Edit"></button>
                                    <button type="button" class="btn btn-sm btn-outline-light tool-button tool-download" title="Download"></button>
                                    <button type="button" class="btn btn-sm btn-outline-light tool-button tool-delete" title="Delete"></button>
                                </div>
                                <small class="text-muted"><%= pic.getMoment() %>
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>

            </div>
        </div>
    </div>

</main>

<footer class="text-muted py-5">
    <div class="container">
        <p class="float-end mb-1">
            <a href="#">Back to top</a>
        </p>
        <p class="mb-1">2021 &copy; By Max Dmitriev</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
<script src="js/gallery.js"></script>
</body>

</html>
