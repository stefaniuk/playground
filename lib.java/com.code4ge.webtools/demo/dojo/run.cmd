rm build.profile.js
java -classpath ..\..\build\com.code4ge.webtools.jar;..\..\lib\com.code4ge.json.jar;..\..\lib\jgrapht.jar ^
	com.code4ge.webtools.dojo.CombineProfiles build.profile.js build1.profile.js build2.profile.js
