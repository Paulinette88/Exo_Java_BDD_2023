<%@page import="java.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
<head>
    <title>Gestionnaire de Tâches</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            margin: 40px;
        }
        h1, h2 {
            color: #333;
        }
        form {
            margin-bottom: 20px;
        }
        input[type="text"], input[type="date"] {
            padding: 6px;
            margin: 4px 0;
            width: 250px;
        }
        input[type="submit"] {
            padding: 6px 12px;
            background-color: #4CAF50;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 4px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #e2e2e2;
        }
    </style>
</head>
<body>

<h1>Ajouter une tâche</h1>
<form method="post">
    Titre : <input type="text" name="titre" required><br>
    Description : <input type="text" name="description" required><br>
    Date d'échéance : <input type="date" name="date" required><br>
    <input type="submit" value="Ajouter">
</form>

<%
    ArrayList<String[]> tasks = (ArrayList<String[]>) session.getAttribute("tasks");
    if (tasks == null) {
        tasks = new ArrayList<String[]>();
        session.setAttribute("tasks", tasks);
    }

    String titre = request.getParameter("titre");
    String description = request.getParameter("description");
    String date = request.getParameter("date");
    if (titre != null && description != null && date != null) {
        String[] tache = { titre, description, date, "non" };
        tasks.add(tache);
    }

    String terminer = request.getParameter("terminer");
    if (terminer != null) {
        int i = Integer.parseInt(terminer);
        tasks.get(i)[3] = "oui";
    }

    String supprimer = request.getParameter("supprimer");
    if (supprimer != null) {
        int i = Integer.parseInt(supprimer);
        tasks.remove(i);
    }
%>

<h2>Liste des tâches</h2>
<table>
    <tr>
        <th>Titre</th>
        <th>Description</th>
        <th>Échéance</th>
        <th>Statut</th>
        <th>Actions</th>
    </tr>
<%
    for (int i = 0; i < tasks.size(); i++) {
        String[] tache = tasks.get(i);
%>
    <tr>
        <td><%= tache[0] %></td>
        <td><%= tache[1] %></td>
        <td><%= tache[2] %></td>
        <td><%= tache[3].equals("oui") ? "✔ Terminée" : "⏳ En cours" %></td>
        <td>
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
        </td>
    </tr>
<% } %>
</table>

</body>
</html>
