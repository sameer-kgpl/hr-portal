export interface CandidateKeyword {
  candidate_id: number;
  keywords_json: any; // JSON array or object of keywords and weights
  vector_json: any | null; // optional precomputed vector representation
  updated_at: string;
}