/**
 * Created by zan on 04/02/2014.
 */
package com.mands.raygunas.raygunrequest
{
import flash.display.Stage;

public class Details
{

    public var version:String;
    public var error:ErrorDetails;
    public var environment:Environment;

    public function Details(version:String, error:Error, os:String, mainStage:Stage = null)
    {
        this.version = version;
        this.error = new ErrorDetails(error);
        this.environment = new Environment(mainStage);
        this.environment.getDeviceData(os);
    }
}
}
