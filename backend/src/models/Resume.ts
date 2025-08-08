import { RowDataPacket } from 'mysql2';

export interface Resume extends RowDataPacket {
  id: number;
  candidate_id: number;
  original_filename: string;
  stored_filename: string;
  mime_type: string;
  size_bytes: number;
  text_content: string | null;
  uploaded_at: string;
}