/**
 * Created by zan on 04/02/2014.
 */
package com.mands.raygunas.raygunrequest
{
public class StackLine
{
    public var lineNumber:int;
    public var className:String;
    public var fileName:String;
    public var methodName:String;

    public function StackLine(stackTraceLine:String)
    {
        className = getClassName(stackTraceLine);
        fileName = getFileName(stackTraceLine);
        lineNumber = getFileLineNumber(stackTraceLine);
        methodName = getMethodName(stackTraceLine);

    }

    public static function getClassName( exceptionLine:String ):String
    {
        var classNameBeginIndex:int = 3;
        var classNameEndIndex:int = exceptionLine.indexOf("/");
        if(classNameEndIndex < 0)
            classNameEndIndex = exceptionLine.indexOf("()");

        return exceptionLine.slice(classNameBeginIndex, classNameEndIndex);

    }

    public static function getFileName( exceptionLine:String ):String
    {
        var fileNameBeginIndex:int = exceptionLine.indexOf("[");
        var fileNameEndIndex:int = exceptionLine.lastIndexOf(":");
        if(fileNameBeginIndex >= 0){
            return exceptionLine.slice(fileNameBeginIndex + 1, fileNameEndIndex);
        }
        else{
            return "";
        }
    }

    public static function getMethodName( exceptionLine:String ):String
    {
        var className:String = getClassName(exceptionLine);
        var methodNameBeginIndex:int = exceptionLine.indexOf(className ) + className.length;
        if(exceptionLine.charAt(methodNameBeginIndex) == "/"){
            methodNameBeginIndex++;
        }
        else if(exceptionLine.charAt(methodNameBeginIndex) == "("){
            methodNameBeginIndex = exceptionLine.indexOf("::")+2;
        }
        var methodNameEndIndex:int = exceptionLine.indexOf("()");
        return exceptionLine.slice(methodNameBeginIndex, methodNameEndIndex+2);
    }

    public static function getFileLineNumber(exceptionLine:String):int
    {
        var numberIndex:int = exceptionLine.indexOf(".as:");
        if(numberIndex <= 0)
        {
            return -1;
        }
        else  {
            return parseInt(exceptionLine.slice(numberIndex+4, exceptionLine.length-1 ));
        }
    }

}
}
