/* 
 * These two classes represent colors in HSV format (which can be converted to RGB)
 * One class uses floating point numbers (HSVColorf) the other uses ints for speed (HSVColori)
 * Borrowed some code (most of toRGB) from the excellent toxiclibs - http://toxiclibs.org
 * Optimized (a bit) for C++ and the Arduino
 *
 * by Evan Raskob <evan@openlabworkshops.org>
 
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
#ifndef HSVColor_h
#define HSVColor_h


class HSVColori
{
public:

  int h;
  int s;
  int v;


  HSVColori(): 
  h(0), s(0), v(0)
  { 
  }

  HSVColori(int _h, int _s, int _v): 
  h(_h), s(_s), v(_v)
  { 
  }

  static const int INV_INV60DEGREES = 6; //  = 360 / 60

  void set(int _h, int _s, int _v)
  {
    h = _h;
    s = _s;
    v = _v;
  }

  HSVColori& shiftHue(int amt)
  {
    h = (h + amt) & 0xFF;
  }

  HSVColori& brighten(int amt)
  {
    v = (v + amt) & 0xFF;
  }

  HSVColori& saturate(int amt)
  {
    s = (s + amt) & 0xFF;
  }

  // Convert a color in H,S,V to RGB
  static void toRGB(int _h, int _s, int _v, int* rgb) 
  {
    if (_s < 1)
    {
      rgb[0] = rgb[1] = rgb[2] = _v;
    } 
    else 
    {
      _h *= INV_INV60DEGREES;
      int i = _h;
      int f = _h - i;
      int p = _v * (255 - _s);
      int q = _v * (255 - _s * f);
      int t = _v * (255 - _s * (255 - f));

      if (i == 0) {
        rgb[0] = _v;
        rgb[1] = t;
        rgb[2] = p;
      } 
      else if (i == 1) {
        rgb[0] = q;
        rgb[1] = _v;
        rgb[2] = p;
      } 
      else if (i == 2) {
        rgb[0] = p;
        rgb[1] = _v;
        rgb[2] = t;
      } 
      else if (i == 3) {
        rgb[0] = p;
        rgb[1] = q;
        rgb[2] = _v;
      } 
      else if (i == 4) {
        rgb[0] = t;
        rgb[1] = p;
        rgb[2] = _v;
      } 
      else {
        rgb[0] = _v;
        rgb[1] = p;
        rgb[2] = q;
      }
    }
    // end toRGB
  }


  // Convert THIS color to RGB
  void toRGB(int* rgb) 
  {
    toRGB(h, s, v, rgb);
    // end toRGB
  }

  // 
  // transition between two colors smoothly (linear interpolation)
  //
  static void lerp(const HSVColori& first, const HSVColori& second, HSVColori& result, int amount)
  {
    int minus_amount = 255-amount;
    result.h = (first.h*minus_amount + second.h*amount) / 255;
    result.s = (first.s*minus_amount + second.s*amount) / 255;
    result.v = (first.v*minus_amount + second.v*amount) / 255;
  }

  // 
  // transition between THIS color and a second smoothly (linear interpolation)
  //
  void lerp(const HSVColori& second, HSVColori& result, int amount)
  {
    lerp( (*this), second, result, amount );
  }

  // 
  // transition between THIS color and a second smoothly (linear interpolation)
  //
  HSVColori& lerp(const HSVColori& second, int amount)
  {
    lerp( (*this), second, (*this), amount );
    return (*this);
  }

  HSVColori& operator=(const HSVColori& rhs) { 
    if (this != &rhs) 
    { 
      // check for self-assignment
      this->h = rhs.h;
      this->s = rhs.s;
      this->v = rhs.v;
    }
    return *this;
  }

  bool operator==(const HSVColori& rhs) {  
    if (this == &rhs) return true;

    return 
      (
    this->h == rhs.h &&
      this->s == rhs.s &&
      this->v == rhs.v 
      );
  }

  bool operator!=(const HSVColori& rhs) 
  {  
    return !(*this == rhs);
  }

  //end class HSVColori
};




class HSVColorf
{
public:

  float h;
  float s;
  float v;


  HSVColorf(): 
  h(0.0f), s(0.0f), v(0.0f)
  { 
  }

  HSVColorf(float _h, float _s, float _v): 
  h(_h), s(_s), v(_v)
  { 
  }

  static const float INV_INV60DEGREES = 6.0f; //  = 360 / 60

  void set(float _h, float _s, float _v)
  {
    h = _h;
    s = _s;
    v = _v;
  }

   
   HSVColorf& shiftHue(float amt)
   {
     float tmp = h + amt;
     
     // just get decimal - we're in the range 0-1 here only
     tmp = tmp - int(tmp);
     
     if (tmp<0)
     {
       tmp = 1.0f - tmp;
     }
     h = tmp;
   }
   
   
   HSVColorf& brighten(float amt)
   {
     float tmp = v + amt;
     
     // just get decimal - we're in the range 0-1 here only
     tmp = tmp - int(tmp);
     
     if (tmp<0)
     {
       tmp = 1.0f - tmp;
     }
     v = tmp;
   }
   
   HSVColorf& saturate(float amt)
   {
     float tmp = s + amt;
     
     // just get decimal - we're in the range 0-1 here only
     tmp = tmp - int(tmp);
     
     if (tmp<0)
     {
       tmp = 1.0f - tmp;
     }
     s = tmp;
   }
   
   
  // Convert a color in H,S,V to RGB
  static void toRGB(float _h, float _s, float _v, float* rgb) 
  {
    if (_s < 10e-5)
    {
      rgb[0] = rgb[1] = rgb[2] = _v;
    } 
    else 
    {
      _h *= INV_INV60DEGREES;
      int i = (int)_h;
      float f = _h - i;
      float p = _v * (1 - _s);
      float q = _v * (1 - _s * f);
      float t = _v * (1 - _s * (1 - f));

      if (i == 0) {
        rgb[0] = _v;
        rgb[1] = t;
        rgb[2] = p;
      } 
      else if (i == 1) {
        rgb[0] = q;
        rgb[1] = _v;
        rgb[2] = p;
      } 
      else if (i == 2) {
        rgb[0] = p;
        rgb[1] = _v;
        rgb[2] = t;
      } 
      else if (i == 3) {
        rgb[0] = p;
        rgb[1] = q;
        rgb[2] = _v;
      } 
      else if (i == 4) {
        rgb[0] = t;
        rgb[1] = p;
        rgb[2] = _v;
      } 
      else {
        rgb[0] = _v;
        rgb[1] = p;
        rgb[2] = q;
      }
    }
    // end toRGB
  }


  // Convert THIS color to RGB
  void toRGB(float* rgb) 
  {
    toRGB(h, s, v, rgb);
    // end toRGB
  }

  // 
  // transition between two colors smoothly (linear interpolation)
  //
  static void lerp(const HSVColorf& first, const HSVColorf& second, HSVColorf& result, float amount)
  {
    float minus_amount = 1.0f-amount;
    result.h = first.h*amount + second.h*minus_amount;
    result.s = first.s*amount + second.s*minus_amount;
    result.v = first.v*amount + second.v*minus_amount;
  }

  // 
  // transition between THIS color and a second smoothly (linear interpolation)
  //
  void lerp(const HSVColorf& second, HSVColorf& result, float amount)
  {
    lerp( (*this), second, result, amount );
  }

  // 
  // transition between THIS color and a second smoothly (linear interpolation)
  //
  void lerp(const HSVColorf& second, float amount)
  {
    lerp( (*this), second, (*this), amount );
  }

  HSVColorf& operator=(const HSVColorf& rhs) { 
    if (this != &rhs) 
    { 
      // check for self-assignment
      this->h = rhs.h;
      this->s = rhs.s;
      this->v = rhs.v;
    }
    return *this;
  }

  bool operator==(const HSVColorf& rhs) 
  {  
    if (this == &rhs) return true;

    return 
      (
    this->h == rhs.h &&
      this->s == rhs.s &&
      this->v == rhs.v 
      );
  }

  bool operator!=(const HSVColorf& rhs) 
  {  
    return !(*this == rhs);
  }

  //end class HSVColorf
};

#endif
