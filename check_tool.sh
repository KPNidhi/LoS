echo "ENTER THE TOOL NAME:"
read tool
if which $tool > /dev/null
then
   echo "$tool IS INSTALLED"
else
   echo "$tool IS NOT INSTALLED"
fi

