<%@page import="java.util.*" %> <%-- On importe les outils Java pour utiliser des listes comme ArrayList --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%> <%-- On définit le type de contenu et l'encodage de la page --%>

<html>
<head>
    <title>Gestionnaire de Tâches</title> <%-- Titre de la page affiché dans l’onglet du navigateur --%>
</head>
<body>

<h1>Ajouter une tâche</h1>
<%-- Formulaire pour saisir une tâche avec son titre, sa description et sa date d’échéance --%>
<form method="post">
    Titre : <input type="text" name="titre" required><br> <%-- Champ obligatoire pour le titre --%>
    Description : <input type="text" name="description" required><br> <%-- Champ obligatoire pour la description --%>
    Date d’échéance : <input type="date" name="date" required><br> <%-- Champ de type date pour l’échéance --%>
    <input type="submit" value="Ajouter"> <%-- Bouton pour soumettre le formulaire --%>
</form>

<%
    // On récupère la liste de tâches stockée dans la session de l'utilisateur
    ArrayList<String[]> tasks = (ArrayList<String[]>) session.getAttribute("tasks");

    // Si c'est la première fois que l'utilisateur vient, on initialise la liste vide
    if (tasks == null) {
        tasks = new ArrayList<String[]>(); // On crée une nouvelle liste vide
        session.setAttribute("tasks", tasks); // On l’enregistre dans la session
    }

    // Récupération des données du formulaire si l'utilisateur vient d'ajouter une tâche
    String titre = request.getParameter("titre"); // Le titre de la tâche
    String description = request.getParameter("description"); // La description
    String date = request.getParameter("date"); // La date d’échéance

    // Si les 3 champs sont remplis, on ajoute la tâche à la liste
    if (titre != null && description != null && date != null) {
        String[] tache = { titre, description, date, "non" }; // "non" = tâche pas encore terminée
        tasks.add(tache); // On ajoute la tâche à la liste
    }

    // Si l’utilisateur a cliqué sur "Terminer", on met le statut de la tâche à "oui"
    String terminer = request.getParameter("terminer");
    if (terminer != null) {
        int i = Integer.parseInt(terminer); // On convertit l’index en nombre
        tasks.get(i)[3] = "oui"; // On met "oui" dans le champ statut
    }

    // Si l’utilisateur a cliqué sur "Supprimer", on retire la tâche de la liste
    String supprimer = request.getParameter("supprimer");
    if (supprimer != null) {
        int i = Integer.parseInt(supprimer); // On convertit l’index
        tasks.remove(i); // On supprime la tâche
    }
%>

<h2>Liste des tâches</h2>
<ul>
<%
    // On affiche chaque tâche sous forme de liste
    for (int i = 0; i < tasks.size(); i++) {
        String[] tache = tasks.get(i); // On récupère la tâche à l’index i
%>
    <li>
        <b><%= tache[0] %></b> - <%= tache[1] %> (Échéance : <%= tache[2] %>)<br>
        <%-- On affiche le titre, la description et la date --%>

        Statut : <%= tache[3].equals("oui") ? "✔ Terminée" : "⏳ En cours" %><br>
        <%-- On affiche "Terminée" ou "En cours" selon le statut --%>

        <% if (!tache[3].equals("oui")) { %> <%-- Si la tâche n’est pas terminée, on propose de la terminer --%>
        <form method="post" style="display:inline;">
            <input type="hidden" name="terminer" value="<%= i %>"> <%-- On envoie l'index de la tâche à terminer --%>
            <input type="submit" value="Terminer">
        </form>
        <% } %>

        <%-- Bouton pour supprimer la tâche --%>
        <form method="post" style="display:inline;">
            <input type="hidden" name="supprimer" value="<%= i %>"> <%-- On envoie l'index de la tâche à supprimer --%>
            <input type="submit" value="Supprimer">
        </form>
        <br><br>
    </li>
<% } %>
</ul>

</body>
</html>
