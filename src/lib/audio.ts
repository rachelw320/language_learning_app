// One audio element shared by the whole app. Ios only lets a page play sound after the user has tapped something,
// and once an element has been unlocked by that first tap it can keep playing, so reusing it makes autoplay on later cards work
let player: HTMLAudioElement | null = null;

/** Plays an audio file and resolves when it finishes. Rejects if the file is missing or the browser won't play it */
export function playAudio(src: string): Promise<void> {
	return new Promise((resolve, reject) => {
		if (!player) {
			player = new Audio();
		}
		player.src = src;
		player.load();
		player.onended = () => resolve();
		player.onerror = () => reject(new Error(`Couldn't play ${src} :(`));
		player.play().catch(reject);
	});
}
