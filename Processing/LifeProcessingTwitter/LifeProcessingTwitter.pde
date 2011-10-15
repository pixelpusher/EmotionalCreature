/**
 * Adapted from:
 * "Just a simple Processing and Twitter thingy majiggy"
 * by RobotGrrl.com
 *
 * Code licensed under:
 * CC-BY
 * 
 * by Fiona French, Evan Raskob, alan Shaw, and others on the Game Of Life Project
 * by Openlab Workshops http://openlabworkshops.org and SPACE Studios http://spacestudios.org.uk 
 * http://lifeproject.spacestudios.org.uk
 * 2011
 *
 * Uses Apache's lang methods: http://commons.apache.org/lang/
 * Uses Twitter4j: http://twitter4j.org/en/index.html
 *
 *
 * 10 Twitter applications have been registered at dev.twitter.com
 * Each 1 updates a different Twitter account, 1 for each creature
 * You need the keys and codes associated with each account in order
 * to make any updates (tweet).
 *
 *
 * The .ini file contains the twitter account keys for each creature.  Obviously, it is not included in the 
 * public distribution!
 *
 * The format for each creature's twitter account entry in the .ini file is:
 *
 [creature_name]
 OAuthConsumerKey = xxxxxxxxxxx
 OAuthConsumerSecret = xxxxxxxxxx
 AccessToken = xxxxxxxxxx
 AccessTokenSecret = xxxxxxxxx
 
 *
 **/

import org.apache.commons.lang3.StringUtils; // from http://commons.apache.org/lang/



// INI file name containing twitter credentials
static final String CREDS_FILE = "twitter.creds.ini";

// Stores all the credentials in a list for easy access
LinkedList<Credentials> creatureCreds;

final String[] emotions = {
  "happy", "sad", "angry", "bored", "disgusted", "surprised", "horny", "anti-social"
};


//int th_index = int(random(things.length)); 
//String neighbour = things[th_index];
//int feel_index = int(random(feeling.length)); 
//String emotion = feeling[feel_index];

String currentCreatureAccount = "";


void setup() 
{
  size(320, 240);
  background(0);

  creatureCreds = getCredentials(CREDS_FILE);

  // DEBUG:
  for (Credentials cred : creatureCreds)
  {
    println("Credentials: " + cred);
  }

  Credentials cred = null;

  try
  {
    cred = creatureCreds.getLast();
  }
  catch ( Exception e)
  {
    println("Failed getting proper credentials:");
    println( e.getMessage() );
    e.printStackTrace();
    exit();
  }
  finally
  {
    currentCreatureAccount = cred.name;


    connectTwitter(cred);

    println("Getting search tweets:");
    String[] tweets = getSearchTweets("@"+cred.name);
    for (String tweet : tweets)
      println(tweet);

    println("Getting timeline:");
    String[] statuses = getTimeline();
    for (String status : statuses)
      println(status);
  try
  { 
    println("Folowed by " + getNumberFollowers(cred.name));
  }
  catch ( TwitterException e)
  {
    println("Failed getting followers from Twitter[" + e.getStatusCode() + "]");
    println( e.getMessage() );
  }

  
  }
}


void tweetStatusChange(String fromCreatureName, String emotionName)
{
  int s = second();  // Values from 0 - 59
  int mi = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  int d = day();    // Values from 1 - 31
  int mo = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.
  
  String myTweet = "I felt " +emotionName+ " from @" +fromCreatureName+ " and it made me " +emotionName+ " at " +h+ ":" +mi+ ":" +s+ " - " +d+ "/" +mo+ "/" +y+ "";
  sendTweet(myTweet);
}



// This gets current date/time and uses in the tweet.
// Twitter checks for repetition, and won't display same message twice, so timestamp
// ensures tweet is tweeted.

void draw() 
{

  background(204);
  // call the sendTweet function on a keypress - can be any bit of code that calls the function.
  if (keyPressed) 
  {
    if (key == ENTER) 
    {
      tweetStatusChange(currentCreatureAccount, emotions[int(random(emotions.length))] );
    }
  }
}















