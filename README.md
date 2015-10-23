# salesforce-datetime-utils

Like multi-currency support for time zones, this utility will allow you 
to easily represent a date/time field as a static text string in any 
defined time zone.

## Purpose

The purpose of this package is to convert a date/time value to a specified 
time zone, then output a text string which can be easily used in other 
places across your application. 

A custom setting is provided where you can specify which field to convert, 
which field provide the desired time zone value, and which field the result 
should be stored in. Many conversions can be performed per record, and the 
calculations are object-agnostic. So that you can easily configure the criteria 
for performing calculations, there's no apex trigger code included and you can 
run the code from a Process Builder process.

## Setup

1. Follow this link to install the unmanaged package:

  https://goo.gl/4cwVvI

  Installation as an administrator is probably fine as users will be 
  triggering the classes via workflow and therefore will not require 
  direct access to them. If a specific user needs to build the workflow 
  in Process Builder, grant their profile access also.
  
2. Follow the instructions in this video to map source fields to their respective 
   targets, then designate the text fields which store the target time zone(s).

   https://goo.gl/O10zX9
