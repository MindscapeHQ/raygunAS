/**
 * Created by zan on 04/02/2014.
 */
package com.mands.raygunas.raygunrequest
{

import flash.display.Stage;

public class Environment
{
    public var osVersion:String;
    public var deviceName:String;
    public var currentOrientation:String;
    public var windowBoundsWidth:Number;
    public var windowBoundsHeight:Number;

    public function Environment(mainStage:Stage = null, deviceName:String = null, osVersion:String = null)
    {
        if(mainStage != null){
            windowBoundsHeight = mainStage.height;
            windowBoundsWidth = mainStage.width;
            currentOrientation = mainStage.orientation;
        }
        if(deviceName != null){
            this.deviceName = deviceName;
        }
        if(osVersion != null){
            this.osVersion = osVersion;
        }
    }

}
}
