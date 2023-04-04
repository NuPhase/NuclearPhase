import pygame
from pygame.math import Vector2
import math

pygame.init()
pygame.font.init()

WIDTH = 480
HEIGHT = 480

FONT = pygame.font.SysFont('arial', 10)
FONTC = pygame.font.SysFont('arial', 14)
# BORDER = pygame.Rect(WIDTH//2 - 5, 0, 10, HEIGHT)

FPS = 60

screen = pygame.display.set_mode((WIDTH, HEIGHT))

clock = pygame.time.Clock()
running = True
vector = Vector2(0, 0)
pointer_vector = Vector2(0, 0)

acceleration = 2.5
drag_mult = 0.95
maxspeed = 200

lastx = 0
lasty = 0
delay = 5

def between(low, middle, high):
    return max(min(middle, high), low)


def Interpolate(a, b, w):
    return a + (b - a) * w

def process_inertia():
    if(pygame.time.get_ticks() > lastx + delay):
        if(abs(vector.x) <= 0.1):
            vector.x = 0
        else:
            vector.x = round(Interpolate(vector.x, 0, 1 - drag_mult), 2)

    if(pygame.time.get_ticks() > lasty + delay):
        if(abs(vector.y) <= 0.1):
            vector.y = 0
        else:
            vector.y = round(Interpolate(vector.y, 0, 1 - drag_mult), 2)

def force(pos):
    global lastx
    global lasty
    pointer_vector.x = pos[0] - WIDTH/2
    if(round(pointer_vector.x)):
        lastx = pygame.time.get_ticks()
    pointer_vector.y = HEIGHT/2 - pos[1]
    if(round(pointer_vector.y)):
        lasty = pygame.time.get_ticks()

NON = 0x0
NORTH = 0x1000
SOUTH = 0x0100
WEST  = 0x0010
EAST = 0x0001
NORTHEAST = NORTH | EAST
NORTHWEST = NORTH | WEST
SOUTHEAST = SOUTH | EAST
SOUTHWEST = SOUTH | WEST

dirs = {

    NORTH: 90,
    SOUTH: -90,
    WEST: 180,
    EAST: 0,
    NORTHWEST: 135,
    NORTHEAST: 45,
    SOUTHWEST: -135,
    SOUTHEAST: -45,
    NORTH | SOUTH: None,
    WEST | EAST: None,
    NORTHEAST | SOUTHWEST: None,
    NORTH | SOUTHWEST: None,
    NORTH | SOUTHEAST: None,
    WEST | SOUTHEAST: None,
    WEST | NORTHEAST: None,
    NON: None
}



while running:
    clock.tick(FPS)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.MOUSEBUTTONUP:
            if event.button == 1:
                pointer_vector.y = 0
                pointer_vector.x = 0


    keys = pygame.key.get_pressed()
    bitdir = 0x0000
    bitdir = bitdir | (NORTH * keys[pygame.K_DOWN])
    bitdir = bitdir | (SOUTH* keys[pygame.K_UP])
    bitdir = bitdir | (WEST* keys[pygame.K_LEFT])
    bitdir = bitdir | (EAST* keys[pygame.K_RIGHT])
    angle = dirs[bitdir]
    if(not(angle is None)):
        angle = dirs[bitdir]

        pos = [round(math.cos(angle*(math.pi/180))*maxspeed + WIDTH/2, 2), round((math.sin(angle*(math.pi/180))*maxspeed + HEIGHT/2), 2)]
        force(pos)
    else:
        force([WIDTH/2, HEIGHT/2])

    if(pygame.mouse.get_pressed()[0]):
        pos = pygame.mouse.get_pos()
        force(pos)

    if pygame.time.get_ticks() % (FPS*5):
        process_inertia()
        if(pointer_vector.x != 0 or pointer_vector.y != 0):
            vecto = pointer_vector.normalize()
            x = vector.x + (vecto.x*acceleration)
            y = vector.y + (vecto.y*acceleration)
            hip = (x**2 + y**2)**(1/2)
            hipp = between(-maxspeed, hip, maxspeed)

            vector.x = round((x / hip) * hipp, 2)
            vector.y = round(y / hip * hipp, 2)

        # vector.x = vector.x + (vecto.x*acceleration)
        # vector.y = vector.y + (vecto.y*acceleration)

    screen.fill((255, 255, 255))
    pygame.draw.line(screen, (0, 0, 0), [WIDTH/2, HEIGHT], [WIDTH/2, 0], 2)
    pygame.draw.line(screen, (0, 0, 0), [0, HEIGHT/2], [WIDTH, HEIGHT/2], 2)

    for i in range(0, HEIGHT, 30):
        pygame.draw.line(screen, (0, 0, 0), [WIDTH/2-3, i], [WIDTH/2+4, i], 2)
        t = HEIGHT/2 - i
        if(t):
            text = FONT.render(f"{int(t)}", False, (0, 0, 0))
            screen.blit(text, (WIDTH/2-20, i-7))

    for i in range(0, WIDTH, 30):
        pygame.draw.line(screen, (0, 0, 0), [i, HEIGHT/2-3], [i, HEIGHT/2+4], 2)
        t = WIDTH/2 - i
        if(t):
            text = FONT.render(f"{int(t)}", False, (0, 0, 0))
            screen.blit(text, (i-5, HEIGHT/2+20))

    vec2draw1 = Vector2(vector.x + WIDTH/2, HEIGHT-(vector.y + HEIGHT/2))
    pygame.draw.line(screen, (0, 0, 0), [WIDTH/2, HEIGHT/2], vec2draw1, 5)
    vec2draw2 = Vector2(pointer_vector.x + WIDTH/2, HEIGHT-(pointer_vector.y + HEIGHT/2))
    pygame.draw.line(screen, (0, 0, 0), [WIDTH/2, HEIGHT/2], vec2draw2, 1)

    pygame.draw.circle(screen, (0, 0, 0), (WIDTH/2, HEIGHT/2), maxspeed, 3)

    text1 = FONTC.render(f"[VEHICLE] x:{vector.x} y: {vector.y} hip: {round(((vector.x)**2 + (vector.y)**2)**(1/2))}", False, (0, 0, 0))
    text2 = FONTC.render(f"[INERTIA] x:{pointer_vector.x} y: {pointer_vector.y} hip: {round(((pointer_vector.x)**2 + (pointer_vector.y)**2)**(1/2))}", False, (0, 0, 0))
    screen.blit(text1, (0, 0))
    screen.blit(text2, (0, 50))


    pygame.display.flip()

pygame.quit()