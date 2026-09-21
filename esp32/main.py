from machine import Pin, PWM, Timer
from time import sleep, sleep_us
import neopixel
import dht
import network
import ufirebase as firebase


wlan = network.WLAN(network.STA_IF)
wlan.active(True)
wlan.connect("Wokwi-GUEST", "")  

while not wlan.isconnected():
    pass

print("Wi-Fi connecté!")


firebase.setURL("firebase_URL_here")


timer = Timer(0) 


rd_button=Pin(21,Pin.IN) 
ld_button=Pin(26,Pin.IN) 
t_button=Pin(25,Pin.IN) 


NUM_LEDS = 16           
np = neopixel.NeoPixel(Pin(27), NUM_LEDS)

def fill_color(r, g, b):
    for i in range(NUM_LEDS):
        np[i] = (r, g, b)
    np.write()

def update_led_color():
    try:
        firebase.get("r", "r_data", bg=0)
        firebase.get("g", "g_data", bg=0)
        firebase.get("b", "b_data", bg=0) 
        print(f"Couleur reçue : R={firebase.r_data}, G={firebase.g_data}, B={firebase.b_data}")
        fill_color(firebase.r_data, firebase.g_data, firebase.b_data)  
    except:
        print("Erreur lors de la récupération de la couleur LED.")



DHTsensor = dht.DHT22(Pin(14))


RightHeadlight = Pin(17, Pin.OUT)
LeftHeadlight = Pin(16, Pin.OUT)


Engine_step_pin = Pin(32, Pin.OUT)
Engine_dir_pin = Pin(13, Pin.OUT)
def Engine_motor(steps, direction, delay_us=1000):
    Engine_dir_pin.value(direction)
    for _ in range(steps):
        Engine_step_pin.on()
        sleep_us(delay_us)
        Engine_step_pin.off()
        sleep_us(delay_us)

def check_engine_status():
    try:
        firebase.get("engine", "engine_status", bg=0)  
        if firebase.engine_status == "on":
            print("Moteur ON")
            for _ in range(5):  
                Engine_motor(400, direction=1, delay_us=1000)
        elif firebase.engine_status == "off":
            print("🛑 Moteur OFF")
            step_pin.off()
            dir_pin.off()
    except:
        print("Erreur lors de la lecture de l'état du moteur.")



step_pin = Pin(18, Pin.OUT)
dir_pin = Pin(19, Pin.OUT)
def step_motor(steps, direction, delay_us=1000):
    dir_pin.value(direction)
    for _ in range(steps):
        step_pin.on()
        sleep_us(delay_us)
        step_pin.off()
        sleep_us(delay_us)


servo_rd = PWM(12, freq=50) 
servo_ld = PWM(22, freq=50) 
servo_t = PWM(23, freq=50) 

def set_angle(angle, servo_number):
    duty = int((angle / 180) * 102) + 26  
    servo_number.duty(duty)


def read_servo_command(firebase_path, firebase_var, servo):
    try:
        firebase.get(firebase_path, firebase_var, bg=0)  
        state = getattr(firebase, firebase_var)         
        
        if state == "open":
            print(f"{firebase_var} : OPEN")
            set_angle(0, servo)
        elif state == "locked":
            print(f"{firebase_var} : CLOSE")
            set_angle(90, servo)
        elif state == "closed":
            print(f"{firebase_var} : ClOSE")
            set_angle(90, servo)
        else:
            print(f"{firebase_var} : Commande inconnue → {state}")
    except:
        print(f"Erreur lecture de {firebase_path}")


def update_headlights():
    try:
        firebase.get("lights", "hl_data", bg=0)  
        if (firebase.hl_data=="on") :
            LeftHeadlight.on()
            RightHeadlight.on()
        elif (firebase.hl_data=="off"):
            LeftHeadlight.off()
            RightHeadlight.off()            
    except:
        print("Erreur lors de la lecture des phares.")

def ac_on_off():
    firebase.get("ac", "ac_data", bg=0)
    if (firebase.ac_data == "on"):
        step_motor(400, direction=1, delay_us=1000)
    elif (firebase.ac_data == "off"):
        step_pin.off()

     
while True:
    try:
        read_servo_command("left_door", "left_cmd", servo_ld)
        read_servo_command("right_door", "right_cmd", servo_rd)
        read_servo_command("trunk", "trunk_cmd", servo_t)
        DHTsensor.measure() 
        temp = DHTsensor.temperature()
        print('Temperature: %3.1f C' % temp)
        firebase.put("temp", temp, bg=0)
        
        if (temp>28): 
            for i in range (5):
                step_motor(400, direction=1, delay_us=1000) 

        update_led_color() 
        update_headlights()
        check_engine_status()
        ac_on_off()
    except OSError as e:
        print('Failed to read sensor.')