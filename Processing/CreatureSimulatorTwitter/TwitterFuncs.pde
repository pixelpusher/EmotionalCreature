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

// uses twitter4j: http://twitter4j.org/en/index.html

// Functions here:

// void                    sendTweet(String t);
// void                    getTimeline();
// String[]                getSearchTweets(String queryStr);
// int                     getNumberFollowers(String userName) ;
// void                    connectTwitter(Credentials cred);
// LinkedList<Credentials> getCredentials(String iniFile);
// String[]                getTimeline();


// the Twitter master object 
// for debugging only! now inside creatures
//final Twitter twitter = new TwitterFactory().getInstance();



//
// Encapsulates twitter credentials for connecting to a twitter account (using the creature name)
//
class Credentials {
  String name;
  String OAuthConsumerKey;
  String OAuthConsumerSecret;
  String AccessToken;
  String AccessTokenSecret;
  
  String toString()
  {
    return "[name: " + name +"]\n" +
    "[OAuthConsumerKey: " + OAuthConsumerKey +"]\n" +
    "[OAuthConsumerSecret: " + OAuthConsumerSecret +"]\n" +
    "[AccessToken: " + AccessToken +"]\n" +
    "[AccessTokenSecret: " + AccessTokenSecret +"]";
  }
 // end class Credentials
}



//
// Send a tweet using the currently active account
//

void sendTweet(String t, Twitter twitter) {

  try {
    Status status = twitter.updateStatus(t);
    println("Successfully updated the status to [" + status.getText() + "].");
  } 
  catch(TwitterException e) { 
    println("Send tweet: " + e + " Status code: " + e.getStatusCode());
  }
}



//
// Search for tweets, return array of found tweet strings matching this query
//

String[] getSearchTweets(String queryStr, Twitter twitter) 
{
  String[] searchResults = null;
  
  //String queryStr = "@01thing";

  try {
    Query query = new Query(queryStr);    
    query.setRpp(10); // Get 10 of the 100 search results  
    QueryResult result = twitter.search(query);    
    ArrayList tweets = (ArrayList) result.getTweets();    

  searchResults = new String[tweets.size()];

    for (int i=0; i<tweets.size(); i++) {	
      Tweet t = (Tweet)tweets.get(i);	
      String user = t.getFromUser();
      String msg = t.getText();
      Date d = t.getCreatedAt();	
      searchResults[i] = user + ": " + msg;

      // DEBUG:
      println(searchResults[i]);
    }
  } 
  catch (TwitterException e) {    
    println("Search tweets: " + e);
  }
  
  return searchResults;
}



int getNumberFollowers(String userName, Twitter twitter) throws TwitterException
{
  //int friendsCount = extendedFriend.getFriendsCount();
  //int followersCount = extendedFriend.getFollowersCount();  
  IDs ids = twitter.getFollowersIDs(userName, -1);
  int followers = ids.getIDs().length;
  
  // DEBUG
  println("We are being followed by " + followers + " users");

  return followers;
}



/*
 * Load up the access token
 */
private static AccessToken loadAccessToken(Credentials cred) {
  return new AccessToken(cred.AccessToken, cred.AccessTokenSecret);
}




/**
 * Connect to twitter using credentials for an account
 * @param Credentials object containing secret twitter api credentials
 *
 */
void connectTwitter(Credentials cred)
{  
  try 
  {    
    twitter.setOAuthConsumer(cred.OAuthConsumerKey, cred.OAuthConsumerSecret);
    AccessToken accessToken = loadAccessToken(cred);
    twitter.setOAuthAccessToken(accessToken);
  }
  catch ( Exception e)
  {
    println("Failed connecting to Twitter:");
    println( e.getMessage() );
    exit();
  }
}





/**
 * I read a credentials INI file.
 *
 * @param iniFile INI file containing the credentials
 */
LinkedList<Credentials> getCredentials(String iniFile) 
{
  LinkedList<Credentials> creds = new LinkedList<Credentials>();

  String lines[] = loadStrings(iniFile);

  for (int i=0; i < lines.length; i++) {

    String iniLine = lines[i];

    if (StringUtils.isBlank(iniLine)) 
    {
      // skip
      continue;
    } 
    else if (StringUtils.startsWith(iniLine, "[")) 
    {
      // name of creature twitter account entry
      Credentials cred = new Credentials();
      cred.name = StringUtils.strip(iniLine, "[]");
      creds.add(cred);
    } 
    else 
    {
      // Not blank, not a start - must be credentials data.
      // Get last credentials object added to list and add to it.
      Credentials cred;
      
      if (creds.size() > 0)
        cred = creds.getLast();
      else
        cred = new Credentials();
      
      String nameValue[] = StringUtils.split(iniLine, " =");

      if (nameValue != null && nameValue.length == 2) 
      {
        // parse field:
        if (nameValue[0].equals("OAuthConsumerKey")) 
        {
          cred.OAuthConsumerKey = nameValue[1];
        } 
        else if (nameValue[0].equals("OAuthConsumerSecret")) 
        {
          cred.OAuthConsumerSecret = nameValue[1];
        } 
        else if (nameValue[0].equals("AccessToken")) 
        {
          cred.AccessToken = nameValue[1];
        } 
        else if (nameValue[0].equals("AccessTokenSecret")) 
        {
          cred.AccessTokenSecret = nameValue[1];
        }
        // done parsing fields
      }
      else
      {
        println("Credentials PARSE ERROR: badly formed INI entry: " + iniLine);
      }
    }
  }

  return creds;
}



//
// Get tweets for currently active account
//
String[] getTimeline(Twitter twitter) 
{
  String result[] = null;

  try 
  {
    List<Status> statuses = twitter.getUserTimeline();
    result = new String[statuses.size()];

    for (int i=0; i<statuses.size(); i++) 
    {
      Status status = statuses.get(i);
      result[i]  = status.getUser().getName() + ": " + status.getText();
    }
  }
  catch(TwitterException e) 
  { 
    println( "Error: " + e + " :: status code: " + e.getStatusCode() );
  }
  return result;
}
