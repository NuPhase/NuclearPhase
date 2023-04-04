import pygame
from pygame.math import Vector2

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

acceleration = 1
drag_mult = 0.95
maxspeed = 32

def between(low, middle, high):
	return max(min(middle, high), low)


def Interpolate(a, b, w):
	return a + (b - a) * w

def process_inertia():
	if(abs(vector.x) <= 0.1):
		vector.x = 0
	else:
		vector.x = round(Interpolate(vector.x, 0, 1 - drag_mult), 2)

	if(abs(vector.y) <= 0.1):
		vector.y = 0
	else:
		vector.y = round(Interpolate(vector.y, 0, 1 - drag_mult), 2)

while running:
	clock.tick(FPS)
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			running = False
		if event.type == pygame.MOUSEBUTTONDOWN:
			if event.button == 1:
				pointer_vector.x = event.pos[0] - WIDTH/2
				pointer_vector.y = HEIGHT/2 - event.pos[1]
		if event.type == pygame.MOUSEBUTTONUP:
			if event.button == 1:
				pointer_vector.y = 0
				pointer_vector.x = 0
		if event.type == pygame.MOUSEMOTION:
			if event.buttons[0]:
				pointer_vector.x = event.pos[0] - WIDTH/2
				pointer_vector.y = HEIGHT/2 - event.pos[1]

	process_inertia()

	if pygame.time.get_ticks() % (FPS*5):
		if(pointer_vector.x != 0 and pointer_vector.y != 0):
			vecto = pointer_vector.normalize()
			vector.x = between(-maxspeed, vector.x + (vecto.x*acceleration), maxspeed)
			vector.y = between(-maxspeed, vector.y + (vecto.y*acceleration), maxspeed)

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

	text1 = FONTC.render(f"[VEHICLE] x:{vector.x} y: {vector.y} hip: {round(((vector.x)**2 + (vector.y)**2)**(1/2))}", False, (0, 0, 0))
	text2 = FONTC.render(f"[INERTIA] x:{pointer_vector.x} y: {pointer_vector.y} hip: {round(((pointer_vector.x)**2 + (pointer_vector.y)**2)**(1/2))}", False, (0, 0, 0))
	screen.blit(text1, (0, 0))
	screen.blit(text2, (0, 50))


	pygame.display.flip()

pygame.quit()