/**
 * Created by zan on 03/02/2014.
 */
package com.mands.raygunas
{
import com.mands.raygunas.raygunrequest.Environment;
import com.mands.raygunas.raygunrequest.RaygunRequest;
import com.mands.raygunas.utils.Constants;

import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;

public class RaygunAS extends EventDispatcher
{
    public static const NAME:String = "RaygunAS"
    public static const RAYGUN_COMPLETE:String = NAME+"RaygunComplete";

    private var _raygunRequest:RaygunRequest;
    private var _urlLoader:URLLoader;
    private var _urlRequest:URLRequest;

    public function performRequest(version:String, error:Error, os:String, mainStage:Stage = null)
    {
        _raygunRequest = new RaygunRequest(version, error, os, mainStage);
        _raygunRequest.details.environment.addEventListener(Environment.DEVICE_DATA_READY, onEnvironmentVariablesPrepared);
        _raygunRequest.details.environment.getDeviceData(os);
    }

    private function onEnvironmentVariablesPrepared( event:Event ):void
    {
        _urlLoader = new URLLoader();
        _urlRequest = new URLRequest(Constants.RAYGUN_ADDRESS);
        _urlRequest.method = URLRequestMethod.POST;
        _urlRequest.requestHeaders.push(
                new URLRequestHeader(Constants.RAYGUN_APIKEY_HEADER, Constants.RAYGUN_APIKEY)
        );
        _urlRequest.requestHeaders.push(
                new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        );

        _urlRequest.data = JSON.stringify(_raygunRequest);
        _urlLoader.addEventListener(Event.COMPLETE, onRequestComplete);
        _urlLoader.load(_urlRequest);
    }

    private function onRequestComplete( event:Event ):void
    {
        dispatchEvent(new Event(RAYGUN_COMPLETE));
    }

}
}
