import type { CardProgress } from '../types';

const PROGRESS_KEY = 'ea_srs_progress';

export type ProgressMap = Record<string, CardProgress>;

/** Reads progress from local storage. If it's missing or unreadable you just start from scratch */
export function loadProgress(): ProgressMap {
	try {
		return JSON.parse(localStorage.getItem(PROGRESS_KEY) ?? '{}');
	} catch {
		return {};
	}
}

export function saveProgress(progress: ProgressMap): void {
	localStorage.setItem(PROGRESS_KEY, JSON.stringify(progress));
}
