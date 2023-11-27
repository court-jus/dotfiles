import time

print("Input total number")
total = int(input())
run = True
start = None
already_handled = 0
print("Input current value")
while run:
    cv = input()
    try:
        cv = int(cv)
    except ValueError:
        print("bad value")
        continue
    now = time.time()
    if start is None:
        start = now
        already_handled = cv
        continue
    handled = cv - already_handled
    speed = handled / (now - start)
    remaining = total - cv
    print(f"{handled}/{total} ({remaining}) - ${speed} i/s - remain {remaining/speed}s")
