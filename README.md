RaygunAS - Raygun Client for Adobe Air projects
========

Usage
--------
Initialize Raygun in your main Stage instance:

```
_raygunAs = new RaygunAS(this,RAYGUN_API_KEY, APP_VERSION);
        _raygunAs.addEventListener(RaygunAS.READY_TO_ZAP, onRaygunReady);
        _raygunAs.chargeRaygun();
    }

    private function onRaygunReady( event:Event ):void
    {
        //do logic here
    }
    
```

... and you're done!

[Blogpost with more detailed usage](https://markan.me/raygunas-crash-reporting-for-adobe-air-apps/)


<br />

Copyright 2013 Marks and Spencer. All rights reserved.<br />
Use of this source code is governed by a BSD-style license that can be found in the LICENSE handle.

Zan Markan<br />
zan.markan@marks-and-spencer.com<br />


<br />
