<TeXmacs|1.0.7.3>

<style|article>

<\body>
  <doc-data|<doc-title|CS2102 Project Report:
  [Adspace]>|<\doc-author-data|<author-name|Pascal Chatterjee A0075885L and
  Joakim Carselind A0075840A>>
    \;
  <|doc-author-data>
    \;
  </doc-author-data>|<doc-date|<date>>>

  <section|Software>

  We used the Sinatra web framework for the Ruby language, with our DBMS
  being MySQL. To interface with the database we used the Sequel library
  which allowed us to write execute SQL queries directly from our Ruby code.
  We configured Sinatra to use the WEBrick web server and the ERB server page
  language. We did not use the Zone.

  <section|Relational Schema>

  <\code>
    -- Table dbproject.Users\ 

    CREATE TABLE IF NOT EXISTS dbproject.Users (\ 

    \ \ \ username VARCHAR(16) NOT NULL ,\ 

    \ \ \ password VARCHAR(16) NOT NULL ,\ 

    \ \ \ email VARCHAR(32) NOT NULL ,\ 

    \ \ \ creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\ 

    \ \ \ PRIMARY KEY (username) )\ 

    \ \ \ ENGINE = InnoDB;

    \;

    -- Table dbproject.Categories

    CREATE TABLE IF NOT EXISTS dbproject.Categories(\ 

    \ \ \ name VARCHAR(32) PRIMARY KEY)\ 

    \ \ \ ENGINE = InnoDB;

    \;

    -- Table dbproject.Ads

    CREATE TABLE IF NOT EXISTS dbproject.Ads (\ 

    \ \ \ id INT NOT NULL AUTO_INCREMENT,\ 

    \ \ \ title VARCHAR(128) NOT NULL ,\ 

    \ \ \ description TEXT NOT NULL ,\ 

    \ \ \ fk_category VARCHAR(32) NOT NULL ,\ 

    \ \ \ FOREIGN KEY (fk_category) REFERENCES dbproject.Categories(name)\ 

    \ \ \ \ \ \ ON DELETE CASCADE ON UPDATE CASCADE,\ 

    \ \ \ creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,\ 

    \ \ \ fk_username VARCHAR(16) NOT NULL,\ 

    \ \ \ FOREIGN KEY (fk_username) REFERENCES dbproject.Users(username)\ 

    \ \ \ \ \ \ ON DELETE CASCADE ON UPDATE CASCADE,\ 

    \ \ \ PRIMARY KEY (id))\ 

    \ \ \ ENGINE = InnoDB;
  </code>

  <section|Sample SQL Code>

  <subsection|List all the ads in a certain category>

  <verbatim|><verbatim|ads = DB["SELECT * FROM Ads WHERE fk_category = ?
  ORDER BY creation_date DESC",cat]>

  <subsection|Search for an ad>

  <verbatim|ads = DB["SELECT * FROM Ads WHERE fk_category = ? AND (title LIKE
  ? OR description LIKE ? OR fk_username LIKE ?)", category, "%#{query}%",
  "%#{query}%","%#{query}%"]>

  <subsection|Create a new ad>

  <verbatim|DB["INSERT INTO Ads (id, title, description, fk_category,
  creation_date, fk_username) VALUES (null, ?, ?, ?, null, ?)", title,
  description, category,session["username"]].insert>

  <subsection|Show an ad>

  <verbatim|ad = DB["SELECT * FROM Ads A, Users U WHERE A.id = ? AND
  U.username = A.fk_username",id]>

  <subsection|Delete an ad>

  <verbatim|DB["DELETE FROM Ads WHERE id = ?", id].delete>

  <subsection|Update an ad>

  <verbatim|DB["UPDATE Ads SET title = ?, description = ?, fk_category = ?
  WHERE id = ?",title, description,category,id].update>

  <subsection|Find how many ads a user has posted>

  <verbatim|num_ads_query = DB["SELECT COUNT(*) AS number FROM Ads WHERE
  fk_username = ?", username]>
</body>

<\initial>
  <\collection>
    <associate|font-base-size|11>
    <associate|page-medium|paper>
    <associate|page-type|a4>
  </collection>
</initial>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|1>>
    <associate|auto-10|<tuple|3.7|2>>
    <associate|auto-11|<tuple|4.7|2>>
    <associate|auto-12|<tuple|5|3>>
    <associate|auto-13|<tuple|5.1|?>>
    <associate|auto-14|<tuple|1|?>>
    <associate|auto-2|<tuple|2|1>>
    <associate|auto-3|<tuple|3|1>>
    <associate|auto-4|<tuple|3.1|2>>
    <associate|auto-5|<tuple|3.2|2>>
    <associate|auto-6|<tuple|3.3|2>>
    <associate|auto-7|<tuple|3.4|2>>
    <associate|auto-8|<tuple|3.5|2>>
    <associate|auto-9|<tuple|3.6|2>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|toc>
      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|1<space|2spc>Software>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-1><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|2<space|2spc>ER
      Diagram> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-2><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|3<space|2spc>Relational
      Schema> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-3><vspace|0.5fn>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|4<space|2spc>Sample
      SQL Code> <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-4><vspace|0.5fn>

      <with|par-left|<quote|1.5fn>|4.1<space|2spc>List all the ads in a
      certain category <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-5>>

      <with|par-left|<quote|1.5fn>|4.2<space|2spc>Search for an ad
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-6>>

      <with|par-left|<quote|1.5fn>|4.3<space|2spc>Create a new ad
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-7>>

      <with|par-left|<quote|1.5fn>|4.4<space|2spc>Show an ad
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-8>>

      <with|par-left|<quote|1.5fn>|4.5<space|2spc>Delete an ad
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-9>>

      <with|par-left|<quote|1.5fn>|4.6<space|2spc>Update an ad
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-10>>

      <with|par-left|<quote|1.5fn>|4.7<space|2spc>Find how many ads a user
      has posted <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-11>>

      <vspace*|1fn><with|font-series|<quote|bold>|math-font-series|<quote|bold>|5<space|2spc>Screenshots>
      <datoms|<macro|x|<repeat|<arg|x>|<with|font-series|medium|<with|font-size|1|<space|0.2fn>.<space|0.2fn>>>>>|<htab|5mm>>
      <no-break><pageref|auto-12><vspace|0.5fn>
    </associate>
  </collection>
</auxiliary>