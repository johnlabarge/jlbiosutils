JLBIOSUTILS
===================

I'm JLB and these are my utils. 

This is where I will be putting my ios toolbox of simple objects/patterns 
that I or others may want to reuse.  It ain't much, but hopefully it grows over time. 



DynamicProperties
---------------------

DynamicProperties is a simple object for storing properties for an iOS application to its filesystem. To use it, one can extend it, add properties that are declared @dynamic in the implementationn. The properties are dynamic because the setter/getter calls are interecepted and an NSMutableDictionary is used to store the values.  An NSMutableDictionary is used to store the values because NSJSONSerialization knows how to serialize any NSDictionary object (mostly*). 


*There appears to be a bug with NSJSONSerialization such that even if mutable containers are requested, when loading the data, if those containers are empty in the source JSON they are rendered immutable by the framework.  DynamicProperties puts in a simple hack to check for and fix this bug. 


There is a buildlib.sh script for building the static library to a directory (which one subsequently drags onto their project).  There is also a sample iPhone application indicating the use of this utiltity object. 
