CREATE TABLE "cards" (
	"id" text PRIMARY KEY NOT NULL,
	"category" text NOT NULL,
	"additional_categories" jsonb,
	"position" integer NOT NULL,
	"deck" text,
	"english" text NOT NULL,
	"arabic" text NOT NULL,
	"transliteration" text NOT NULL,
	"accepted" jsonb NOT NULL,
	"arabic_variants" jsonb NOT NULL,
	"audio" jsonb NOT NULL,
	"tags" jsonb NOT NULL,
	"notes" text DEFAULT '' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE INDEX "cards_category_idx" ON "cards" USING btree ("category");