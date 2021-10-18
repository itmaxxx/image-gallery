document.addEventListener("DOMContentLoaded", () => {
    for (let btn of document.querySelectorAll(".picture .tool-delete")) {
        btn.addEventListener("click", deleteClick);
    }
    for (let btn of document.querySelectorAll(".picture .tool-download")) {
        btn.addEventListener("click", downloadClick);
    }
    for (let btn of document.querySelectorAll(".picture .tool-edit")) {
        btn.addEventListener("click", editClick);
    }
});

function editClick(e) {
    // Get card body
    const container = e.target.parentNode.parentNode.parentNode;
    const btnsContainer = e.target.parentNode;

    const pid = findPictureId(container);

    const descr = container.querySelector("p");

    // Edit mode if no saved text
    if (typeof descr.savedText == 'undefined') {
        descr.setAttribute("contenteditable", "true");
        descr.focus();
        descr.savedText = descr.innerText;

        e.target.style["background-position"] = "50% 50%";

        const cancelBtn = document.createElement("button");
        cancelBtn.className = "btn btn-sm btn-outline-light tool-button";
        cancelBtn.style["background-position"] = "50% 0";
        cancelBtn.onclick = () => {
            descr.innerText = descr.savedText;
            delete descr.savedText;

            descr.removeAttribute("contenteditable");

            e.target.style["background-position"] = "0 0";

            btnsContainer.removeChild(cancelBtn);
        };

        btnsContainer.appendChild(cancelBtn);
        container.cancelBtnRef = cancelBtn;
    } else {
        // Save changes
        descr.removeAttribute("contenteditable");

        e.target.style["background-position"] = "0 0";

        btnsContainer.removeChild(container.cancelBtnRef);
        delete container.cancelBtnRef;

        if (descr.savedText !== descr.innerText) {
            fetch(window.location.href, {
                method: "PUT",
                body: JSON.stringify({id: pid, description: descr.innerText}),
                headers: {
                    "Content-Type": "application/json; charset=utf-8"
                }
            }).then(r => r.json()).then(j => {
                if (j.status > 0) {
                    alert("Image info updated successfully");

                    delete descr.savedText;
                } else {
                    alert("Failed to update image info");

                    descr.innerText = descr.savedText;

                    delete descr.savedText;
                }
            });
        } else {
            delete descr.savedText;
        }

    }
}

function deleteClick(e) {
    const cardBody = e.target.parentNode.parentNode.parentNode;
    const pictureCard = cardBody.parentNode.parentNode;
    const pid = findPictureId(cardBody);

    if (confirm("Are you sure you want to delete image?")) {
        fetch("?id=" + pid, {method: "delete"})
            .then(resp => resp.json())
            .then(json => {
                if (json.error) {
                    alert(json.message);
                } else {
                    // Remove picture item from books container
                    pictureCard.parentNode.removeChild(pictureCard);
                }
            });
    }
}

function downloadClick(e) {
    const container = e.target.parentNode.parentNode.parentNode;
    const pid = findPictureId(container);

    window.location = "download/" + pid;
}

function findPictureId(container) {
    const tt = container.querySelector("tt");

    if (!tt) throw "tt not found in parent node";

    return tt.innerHTML;
}