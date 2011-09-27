import org.apache.commons.lang.StringUtils; // http://commons.apache.org/lang/

/*
Adapted from this ...
Just a simple Processing and Twitter thingy majiggy
RobotGrrl.com

Code licensed under:
CC-BY

by Fiona French in July 2011 ...
*/

// 10 Twitter applications have been registered at dev.twitter.com
// Each 1 updates a different Twitter account, 1 for each creature
// You need the keys and codes associated with each account in order
// to make any updates (tweet).

// INI file to read in credentials
static final String CREDS_FILE = "twitter.creds.ini";

// Encapsulates twitter creds (and the creature name)
class Credentials {
  String name;
  String OAuthConsumerKey;
  String OAuthConsumerSecret;
  String AccessToken;
  String AccessTokenSecret;
}

// Stores all the credentials
List<Credentials> creds;

// Just some random variables kicking around
String myTimeline;
java.util.List statuses = null;
User[] friends;
Twitter twitter = new TwitterFactory().getInstance();
RequestToken requestToken;
String[] theSearchTweets = new String[11];

String[] things = { "01thing", "02thing", "03thing", "04thing" };
String[] feeling = {"happy", "sad", "angry", "bored", "disgusted", "surprised", "horny", "anti-social"};
int th_index = int(random(things.length)); 
String neighbour = things[th_index];
int feel_index = int(random(feeling.length)); 
String emotion = feeling[feel_index];
  
void setup() {
  
  creds = getCredentials(CREDS_FILE);
  
  size(100,100);
  background(0);
  connectTwitter();
  getSearchTweets();
  getTimeline();
  //getNumberFollowers();
  //println(neighbour);
}

/**
* I read a credentials INI file.
*
* @param iniFile INI file containing the credentials
*/
List<Credentials> getCredentials(String iniFile) {
  
  ArrayList<Credentials> creds = new ArrayList<Credentials>();
  Credentials cred;

  String lines[] = loadStrings(iniFile);
  
  for (int i=0; i < lines.length; i++) {
    
    String line = lines[i];
    
    if(StringUtils.isBlank(line)) {
      
      continue;
      
    } else if(StringUtils.startsWith(line, "[")) {
      
      cred = new Credentials();
      cred.name = StringUtils.strip(line, "[]");
      creds.add(cred);
      
    } else {
      
      String nameValue[] = StringUtils.split(line, " =");
      
      if(nameValue != null && nameValue.length == 2) {
        
        if(nameValue[0].equals("OAuthConsumerKey")) {
          
          cred.OAuthConsumerKey = nameValue[1];
          
        } else if(nameValue[0].equals("OAuthConsumerSecret")) {
          
          cred.OAuthConsumerSecret = nameValue[1];
          
        } else if(nameValue[0].equals("AccessToken")) {
          
          cred.AccessToken = nameValue[1];
          
        } else if(nameValue[0].equals("AccessTokenSecret")) {
          
          cred.AccessTokenSecret = nameValue[1];
        }
      }
    }
  }
  
  return creds;
}

// This gets current date/time and uses in the tweet.
// Twitter checks for repetition, and won't display same message twice, so timestamp
// ensures tweet is tweeted.
void draw() {
  int s = second();  // Values from 0 - 59
  int mi = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  int d = day();    // Values from 1 - 31
  int mo = month();  // Values from 1 - 12
  int y = year();   // 2003, 2004, 2005, etc.

  String myTweet = "I feel " +emotion+ " @" +neighbour+ " at " +h+ ":" +mi+ ":" +s+ " - " +d+ "/" +mo+ "/" +y+ "";
  
  background(204);
// call the sendTweet function on a keypress - can be any bit of code that calls the function.
  if (keyPressed){
    if (key == ENTER) {
     sendTweet(myTweet);
    }
  }
  
}


// Initial connection
void connectTwitter() {

  twitter.setOAuthConsumer(creds[1].OAuthConsumerKey, creds[1].OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);

}

// Sending a tweet
void sendTweet(String t) {

  try {
    Status status = twitter.updateStatus(t);
    println("Successfully updated the status to [" + status.getText() + "].");
  } catch(TwitterException e) { 
    println("Send tweet: " + e + " Status code: " + e.getStatusCode());
  }

}


// Loading up the access token
private static AccessToken loadAccessToken(){
  return new AccessToken(AccessToken02, AccessTokenSecret02);
}


// Get your tweets
void getTimeline() {

  try {
    statuses = twitter.getUserTimeline(); 
  } catch(TwitterException e) { 
    println("Get timeline: " + e + " Status code: " + e.getStatusCode());
  }

  for(int i=0; i<statuses.size(); i++) {
    Status status = (Status)statuses.get(i);
    println(status.getUser().getName() + ": " + status.getText());
  }

}

void getNumberFollowers()  {
  
    //String me = "01thing";
    //int friendsCount = extendedFriend.getFriendsCount();
    //int followersCount = extendedFriend.getFollowersCount();
  
   //int howManyFollow = twitter.getAccountTotals();
   //println(howManyFollow);
}

// Search for tweets
void getSearchTweets() {

  String queryStr = "@01thing";

  try {
    Query query = new Query(queryStr);    
    query.setRpp(10); // Get 10 of the 100 search results  
    QueryResult result = twitter.search(query);    
    ArrayList tweets = (ArrayList) result.getTweets();    

    for (int i=0; i<tweets.size(); i++) {	
      Tweet t = (Tweet)tweets.get(i);	
      String user = t.getFromUser();
      String msg = t.getText();
      Date d = t.getCreatedAt();	
      theSearchTweets[i] = msg.substring(queryStr.length()+1);

      println(theSearchTweets[i]);
    }

  } catch (TwitterException e) {    
    println("Search tweets: " + e);  
  }

}

