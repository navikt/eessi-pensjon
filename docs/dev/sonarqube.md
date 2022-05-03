
# Sonarqube (i subprosjektene)

Hentet fra [SONARQUBE](https://docs.sonarqube.org/latest/setup/get-started-2-minutes/)


1. Start sonarQube lokalt
```
docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:latest
```
2. Oppsett av prosjekt, inne i sonarqube
```
1. Click the Create new project button.
2. Give your project a Project key and a Display name and click the Set Up button.
3. Under Provide a token, select Generate a token. Give your token a name, click the Generate button, and click Continue.
4. Select your project's main language under Run analysis on your project, and follow the instructions to analyze your project. Here you'll download and execute a Scanner on your code (if you're using Maven or Gradle, the Scanner is automatically downloaded)
```
3. Resultat fra 2 vil da være en kommando lignende den under, som kjøres i terminal:
````
./gradlew sonarqube \
  -Dsonar.projectKey=eessi-pensjon-xxxxxxx \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=4cb8223815284772475c8f59d898eecaf8020b87
  ````

4. Sjekk resultat på http://localhost:9000/dashboard?id=eessi-pensjon-xxxxxxxx