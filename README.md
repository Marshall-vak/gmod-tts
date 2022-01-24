# gmod-tts
 Moon base alpha tts for gmod
 
# Sending custom tts messages from the server
 The tts supports several gamemodes but what if you it doesn't support yours or what if you want to make it say stuff.
 The tts creates a the following net message to the client.
 I'm not good at explaining this. If you can code you will get the whing below.
 
```
net.Start("tts")		// Start a net message to the client tts.		  | 		  |
	net.WriteEntity(ply) 	// The entity the sound comes from. Not needed if global. | entity	  | Not needed if global is true
	net.WriteString(text) 	// The text you want the tts to say.			  | string	  | required
	net.WriteBool(global) 	// Whether or not the tts is global or not.		  | true or false | required
net.Broadcast() 		// You can use net.Send() 				  |		  |
```
