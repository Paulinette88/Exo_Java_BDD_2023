<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
<head>
    <title>Gestionnaire de Tâches</title>
</head>
<body>
<h1>Ajouter une tâche</h1>
<form method="post">
    Titre : <input type="text" name="titre" required><br>
    Description : <input type="text" name="description" required><br>
    Date d’échéance : <input type="date" name="date" required><br>
    <input type="submit" value="Ajouter">
</form>

<%
    HttpSession session = request.getSession();
    ArrayList<String[]> tasks = (ArrayList<String[]>) session.getAttribute("tasks");

    if (tasks == null) {
        tasks = new ArrayList<String[]>();
        session.setAttribute("tasks", tasks);
    }

    // Ajout
    String titre = request.getParameter("titre");
    String description = request.getParameter("description");
    String date = request.getParameter("date");

    if (titre != null && description != null && date != null) {
        String[] tache = { titre, description, date, "non" }; // non = pas encore terminée
        tasks.add(tache);
    }

    // Terminer une tâche
    String terminer = request.getParameter("terminer");
    if (terminer != null) {
        int i = Integer.parseInt(terminer);
        tasks.get(i)[3] = "oui"; // on marque comme terminée
    }

    // Supprimer une tâche
    String supprimer = request.getParameter("supprimer");
    if (supprimer != null) {
        int i = Integer.parseInt(supprimer);
        tasks.remove(i);
    }
%>

<h2>Liste des tâches</h2>
<ul>
<%
    for (int i = 0; i < tasks.size(); i++) {
        String[] tache = tasks.get(i);
%>
    <li>
        <b><%= tache[0] %></b> - <%= tache[1] %> (échéance : <%= tache[2] %>)<br>
        Statut : <%= tache[3].equals("oui") ? "✔ Terminée" : "⏳ En cours" %><br>
        <% if (!tache[3].equals("oui")) { %>
        <form method="post" style="display:inline;">
            <input type="hidden" name="terminer" value="<%= i %>">
            <input type="submit" value="Terminer">
        </form>
        <% } %>
        <form method="post" style="display:inline;">
            <input type="hidden" name="supprimer" value="<%= i %>">
            <input type="submit" value="Supprimer">
        </form>
        <br><br>
    </li>
<% } %>
</ul>

</body>
</html>
