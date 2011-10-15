/**
 * Creatures simulator for Openlab Workshop's Real Game of Life creatures
 *
 * by Evan Raskob <evan@openlabworkshops.org>
 *
 * requires toxiclibs from http://toxiclibs.org
 *
 * This code generates the interleaved array of external emotional state responses
 * that should be pasted into the EmotionalCreature arduino sketch.  It also creates a graphical
 * representation of each creature so you can test out the probabilities.
 *
 *
 **********************************
 *  Copyright (C) 2011 Evan Raskob and the team at Openlab Workshops' Life Project:
 * <info@openlabworkshops.org> 
 * http://lifeproject.spacestudios.org.uk
 * http://openlabworkshops.org
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ***********************************
 */

import toxi.geom.Vec2D;
import toxi.geom.Rect;
import toxi.geom.Circle;


ArrayList<Creature> creatures = new ArrayList<Creature>();

Creature selectedCreature;

boolean showStateColors = true;

String currentCreatureAccount = "";


void setup()
{
  size(640, 480);

  selectedCreature = null;

  println(maxStates+"");

  setupStates();

  println("= {");
  for (int i=HAPPY; i < EMOTIONS_END; i++)
    for (int j=HAPPY; j < EMOTIONS_END; j++)
      for (int k=HAPPY; k < EMOTIONS_END; k++)
      {
        int index = EmotionStateTo3DIndex(i, j, k);
        //print("("+index+")");

        ExternalStateMap[index] = ExternalStateMap3D[i][j][k];
        //        print(ExternalStateMap3D[index]+"");
        //        if (index < maxStates) print(",");
      }

  for (int i=0; i<maxStates; i++)
  {
    print(ExternalStateMap[i]+"");
    if (i < maxStates-1) print(",");
  }
  println("};");

  boolean goodStateMaps = true; // let's be optimistic here!

  if (testExternalStateMap())
  {
    println("EXTERNAL STATE MAP IS A-OK");
  }
  else goodStateMaps = goodStateMaps && false;

  if (testInternalStateMap())
  {
    println("INTERNAL STATE MAP IS A-OK");
  }
  else goodStateMaps = goodStateMaps && false;


  // if it fails, might as well quit now!
  //if (!goodStateMaps) exit();

  //
  // Twitter stuff
  //
  creatureCreds = getCredentials(CREDS_FILE);

  // DEBUG:
  for (Credentials cred : creatureCreds)
  {
    //    println("Credentials: " + cred);
    currentCreatureAccount = cred.name;
    //    connectTwitter(cred);

    // create a new creature from this account
    Creature creature = new Creature(random(60, width-60), random(80, height-80), 60.0f, 80.0f, 40.0f);
    creature.credentials = cred;
    creature.initTwitter();
    creature.rotateSelf(random(0, TWO_PI));
    creatures.add( creature );
    println("New creature: " + cred.name);


    println("Getting search tweets:");
    String[] tweets = getSearchTweets("@"+cred.name, creature.getTwitter());
    for (String tweet : tweets)
      println(tweet);

    println("Getting timeline:");
    String[] statuses = getTimeline(creature.getTwitter());
    for (String status : statuses)
      println(status);
    try
    { 
      println("Folowed by " + getNumberFollowers(cred.name, creature.getTwitter()));
    }
    catch ( TwitterException e)
    {
      println("Failed getting followers from Twitter[" + e.getStatusCode() + "]");
      println( e.getMessage() );
    }
  }
  //
  // done with twitter stuff
  //


  textSize(18);
}



void draw()
{
  smooth();
  fill(0, 20);
  rect(0, 0, width, height);


  // draw states menu
  if (showStateColors)
  {

    fill(80, 255);
    rect(0, 0, 150, EMOTIONS_END*24+5);
  }

  // draw creatures

  for (Creature creature : creatures)
  {
    // rotate mouseX, mouseY into creature coords

    creature.update(millis());

    // test for broadcast...
    if (creature.mBroadcastingEmotion)
    {
      for (Creature c : creatures)
      {
        if (creature != c)
        {
          Vec2D[] intersections = creature.mBeamPoint.intersectsCircle(c.mBeamPoint);
          if (intersections != null && intersections.length > 0)
          {
            //Hit!
            fill(0, 255, 0, 80);
            for (Vec2D vis : intersections)
            {
              ellipse(vis.x, vis.y, 6, 6);
            }
            int pe = creature.mEmotion;

            creature.setEmotion( updateExternalEmotionalState(creature.mEmotion, c.mEmotion) );

            if (creature.mEmotion != pe) 
            {
              int s = second();  // Values from 0 - 59
              int mi = minute();  // Values from 0 - 59
              int h = hour();    // Values from 0 - 23
              int d = day();    // Values from 1 - 31
              int mo = month();  // Values from 1 - 12
              int y = year();   // 2003, 2004, 2005, etc.

              creature.tweet(c.credentials.name + " made me " + states[creature.mEmotion] +" at "+h+ ":" +mi+ ":" +s+ " - " +d+ "/" +mo+ "/" +y);
            }
          }
        }
      }
    }

    if (creature == selectedCreature)
    {
      fill(255, 40);
      noStroke();
      pushMatrix();
      translate(creature.x, creature.y);
      rotate(creature.mRotation);
      ellipse(creature.width/2, creature.height/2, creature.width*2, creature.height*2);
      popMatrix();
    }
    creature.render();
  }

  // draw states menu
  if (showStateColors)
  {    
    pushMatrix();
    translate(5, -18);
    for (int i=0; i<EMOTIONS_END; ++i)
    {
      translate(0, 24);
      fill( stateColors[i] & 0xeeFFFFFF);
      stroke( stateColors[i] );

      rect( 0, 0, 20, 20 );
      text(states[i], 22, 18);
    }
    popMatrix();
  }
}



void mousePressed()
{

  for (Creature creature : creatures)
  {
    // rotate mouseX, mouseY into creature coords

    Vec2D mRotated = new Vec2D(mouseX-creature.x, mouseY-creature.y);
    mRotated.rotate(-creature.mRotation).addSelf(creature.x, creature.y);

    print("rotation:" + creature.mRotation + "   ");
    print("mx,my:" + mouseX+","+mouseY);
    println("   Rmx,Rmy:" + mRotated.x+","+mRotated.y);

    if (creature.containsPoint( mRotated ))
    {
      selectedCreature = creature;
      println("HIT ONE!");
      break;
    }
  }

  if (selectedCreature == null)
  {
    //    println("New creature!");
    //    Creature creature = new Creature(mouseX, mouseY, 60.0f, 80.0f, 40.0f);
    //    creature.rotateSelf(random(0, TWO_PI));
    //    creatures.add( creature );
  }
  else
  {
    int s = second();  // Values from 0 - 59
    int mi = minute();  // Values from 0 - 59
    int h = hour();    // Values from 0 - 23
    int d = day();    // Values from 1 - 31
    int mo = month();  // Values from 1 - 12
    int y = year();   // 2003, 2004, 2005, etc.

    String myTweet = "I was fed at " +h+ ":" +mi+ ":" +s+ " - " +d+ "/" +mo+ "/" +y+ "";
    selectedCreature.tweet(myTweet);
  }
}


void mouseMoved()
{
}

void mouseReleased()
{
  selectedCreature = null;
}


void mouseDragged()
{
  if (selectedCreature != null)
  {
    if (keyPressed && key == CODED && keyCode == SHIFT)
    {
      selectedCreature.rotateSelf( (mouseY-pmouseY)*0.01f );
    }
    else
    {
      selectedCreature.move( (mouseX-pmouseX), (mouseY-pmouseY) );
    }
  }
}



void keyReleased()
{
  switch(key)
  {
  case 'c': 
    showStateColors = !showStateColors;
    break;
  case 'r':
    for (Creature c : creatures)
      c.mEmotion = HAPPY;
    break;
  }
}


//
// Creature class
//

class Creature extends toxi.geom.Rect
{
  Circle mBeamPoint;
  Credentials  credentials = null;  // twitter account credentials loaded from a file

  float BeamAngle         = PI/4; // radians
  float BeamRadius        = 60.0f; // pixels
  int BeamFlashDuration   = 200;   // flash length in millis
  int BeamTransmitInterval= 2000;   // between external emotion transmissions, in millis

  int InternalChangeInterval= 2000;   // between external emotion transmissions, in millis

  int   mEmotion                = HAPPY;
  float mRotation               = 0.0f; //radians

  int mLastTransmitTime         = 0;  // in millis
  int mLastInternalTime         = 0;
  int mCurrentTime              = 0;  // in millis

  boolean mBroadcastingEmotion  = false;


  private TwitterFactory  twitterFactory = null;

  Creature()
  {
    super(0, 0, 60, 80);
    mBeamPoint = new Circle(30, 0, 10);
  }


  Creature(float _x, float _y, float _w, float _h, float _r)
  {
    super(_x, _y, _w, _h);
    mBeamPoint = new Circle(_w/2+_x, _y, _r);
  }     


  void initTwitter()
  {
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setDebugEnabled(true)
      .setOAuthConsumerKey(credentials.OAuthConsumerKey)
        .setOAuthConsumerSecret(credentials.OAuthConsumerSecret)
          .setOAuthAccessToken(credentials.AccessToken)
            .setOAuthAccessTokenSecret(credentials.AccessTokenSecret);
    twitterFactory = new TwitterFactory(cb.build());
  }

  Twitter getTwitter() 
  {
    Twitter result = null;

    // could use exception here to be cleaner
    if (twitterFactory != null) {
      result = twitterFactory.getInstance();
    }
    return result;
  }


  void update(int timeElapsed)
  {
    mCurrentTime = timeElapsed;

    //update internal state

    if (mCurrentTime-mLastInternalTime >= InternalChangeInterval)
    {
      // change
      mEmotion = updateInternalEmotionalState(mEmotion);
      mLastInternalTime = mCurrentTime;
    }

    //update external state
    if (mCurrentTime-mLastTransmitTime >= BeamTransmitInterval)
    {
      // broadcast
      mBroadcastingEmotion = true;
      mLastTransmitTime = mCurrentTime;
    }
    else
    {
      mBroadcastingEmotion = false;
    }
  }

  //
  // rotate a creature a certain number of radians
  //
  Creature rotateSelf(float amt)
  {  
    mRotation += amt;
    mBeamPoint.subSelf(this.x, this.y).rotate(amt).addSelf(this.x, this.y);

    println("BEAM:" + mBeamPoint);
    return this;
  }


  Creature move(float _x, float _y)
  {
    mBeamPoint.addSelf(_x, _y);
    this.x+=_x;
    this.y+=_y;

    return this;
  }


  Creature setEmotion(int emo)
  {
    if (emo < EMOTIONS_END && emo > 0)
      mEmotion = emo;
    else
      println("Bad emotion:" + emo);

    return this;
  }


  Twitter tweet(String msg)
  {
    Twitter twitter = null;

    try {

      twitter = twitterFactory.getInstance();

      Status status = twitter.updateStatus(msg);
      println("Successfully updated the status to [" + status.getText() + "].");
    } 
    catch(TwitterException e) { 
      println("Send tweet: " + e + " Status code: " + e.getStatusCode());
    }

    return twitter;
  }


  void render()
  {
    pushMatrix();

    // rotate
    translate(x, y);
    rotate(mRotation);
    //    translate(-width/2,-height/2);

    // draw body
    fill( stateColors[mEmotion] );
    stroke(255);
    strokeWeight(2);
    rectMode(CORNER);
    rect(0, 0, this.width, this.height);
    rotate(HALF_PI);
    fill(255);
    text(credentials.name, 10, -this.height/2);
    rotate(-HALF_PI);
    // draw broadcast nub
    pushMatrix();
    translate(this.width/2, 0);
    stroke(128);
    strokeWeight(1);
    //    ellipseMode(CENTER);
    //    ellipse(0, 0, this.width*0.1, this.height*0.1);

    // draw broadcat beam
    arc(0, 0, BeamRadius, BeamRadius, -PI/2-BeamAngle/2, -PI/2+BeamAngle/2);

    popMatrix();

    // done drawing creature
    popMatrix();

    if (mBroadcastingEmotion)
    {
      fill(255, 60);
      ellipseMode(CENTER);
      ellipse(mBeamPoint.x, mBeamPoint.y, mBeamPoint.getRadius()*2, mBeamPoint.getRadius()*2);
    }
  }

  // end Creature class
}

