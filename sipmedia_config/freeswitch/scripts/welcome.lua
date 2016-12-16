session:answer();
while (session:ready() == true) do
local mySound = "/usr/sounds/ivr/8664872.mp3";
    session:setAutoHangup(false);
    session:set_tts_params("flite", "kal");
    session:execute("playback", mySound);
    session:sleep(3000);
    digits = session:getDigits(1, "", 3000);
    if (digits == "1")  then
        session:execute("transfer","9888");
    end
    if (digits == "2")  then
        session:execute("transfer","5000");
    end
    if (digits == "3")  then
        session:execute("transfer","4000");
    end
    if (digits == "4")  then
        session:execute("transfer","9999");
    end
    if (digits == "0")  then
        session:execute("transfer","voipaware@sip.voipuser.org");
    end
end
