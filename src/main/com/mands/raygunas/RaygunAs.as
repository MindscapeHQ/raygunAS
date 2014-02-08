/**
 * Created by zan on 03/02/2014.
 */
package com.mands.raygunas
{
import com.mands.raygunas.raygunrequest.DeviceData;
import com.mands.raygunas.raygunrequest.Environment;
import com.mands.raygunas.raygunrequest.RaygunRequest;
import com.mands.raygunas.utils.Constants;

import flash.display.Sprite;

import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.UncaughtErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.system.Capabilities;

public class RaygunAs extends EventDispatcher
{
    public static const NAME:String = "RaygunAS"
    public static const RAYGUN_COMPLETE:String = NAME+"RaygunComplete";
    public static const READY_TO_ZAP:String=NAME+"ReadyToZap";

    private var _raygunRequest:RaygunRequest;
    private var _urlLoader:URLLoader;
    private var _urlRequest:URLRequest;
    private var _mainSprite:Sprite;
    private var _apiKey:String;
    private var _appVersion:String;
    private var _deviceData:DeviceData;

    public function RaygunAs(mainSprite:Sprite = null, apiKey:String = null, appVersion:String = null)
    {
        _mainSprite = mainSprite;
        _apiKey = apiKey;
        _appVersion = appVersion;
    }

    public function chargeRaygun():void
    {
        _deviceData = new DeviceData();
        _deviceData.addEventListener(DeviceData.DEVICE_DATA_READY, onDeviceDataReady);
        _deviceData.loadDeviceData(Capabilities.os);
    }

    private function onDeviceDataReady( event:Event ):void
    {
        if(_mainSprite != null)
        {
            _mainSprite.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
        }
        dispatchEvent(new Event(READY_TO_ZAP));
    }

    private function uncaughtErrorHandler( event:UncaughtErrorEvent ):void
    {
        event.stopImmediatePropagation();
        performRequest(_appVersion, event.error, _mainSprite.stage, _deviceData.deviceName, _deviceData.osVersion);
    }

    public function performRequest(version:String, error:Error, mainStage:Stage = null, deviceName:String = null, osVersion:String = null):void
    {
        _raygunRequest = new RaygunRequest(version, error, mainStage, deviceName, osVersion);

        _urlLoader = new URLLoader();
        _urlRequest = new URLRequest(Constants.RAYGUN_ADDRESS);
        _urlRequest.method = URLRequestMethod.POST;
        _urlRequest.requestHeaders.push(
                new URLRequestHeader(Constants.RAYGUN_APIKEY_HEADER, _apiKey)
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
        trace("RaygunAS - report zapped successfully!");
        dispatchEvent(new Event(RAYGUN_COMPLETE));
    }

}
}
