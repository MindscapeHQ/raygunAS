/**
 * Created by zan on 04/02/2014.
 */
package com.mands.raygunas.raygunrequest
{
import com.brooksandrus.utils.ISO8601Util;

import flash.display.Stage;

public class RaygunRequest
{

    public var occurredOn:String

    public var details:Details;

    public function RaygunRequest(version:String, error:Error, os:String, mainStage:Stage = null)
    {
        details = new Details(version, error, os, mainStage);

        var dateUtil:ISO8601Util = new ISO8601Util();
        occurredOn = dateUtil.formatExtendedDateTime(new Date());
    }
}
}
